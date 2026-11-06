import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/models/status_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Establishing connection between existing incident model and the Cloud Firestore
class IncidentRepository {
  final FirebaseFirestore _firestore;

  IncidentRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _incidentsCollection =>
      _firestore.collection('incidents');

  // Creation of a new incident and its status history entry
  Future<String> createIncident(Incident incident) async {
    try {
      final incidentRef = _incidentsCollection.doc();
      final historyRef = incidentRef.collection('statusHistory').doc();

      // Batch used to group multiple write operations (CRUD) into a single atomic unit
      // Atomicity ensures either all staged updates succeed together or none of them do
      final batch = _firestore.batch();

      batch.set(incidentRef, {
        ...incident.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final initialHistory = StatusHistory(
        entryId: historyRef.id,
        status: IncidentStatusEnum.submitted,
        updatedBy: incident.reporterId,
        note: 'Incident submitted',
        createdAt: DateTime.now(),
      );

      batch.set(historyRef, {
        ...initialHistory.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      return incidentRef.id;
    } catch (e) {
      throw Exception('Failed to submit incident: $e');
    }
  }

  // Updating an incident's status and recording its history
  Future<void> updateIncidentStatus({
    required String incidentId,
    required IncidentStatusEnum newStatus,
    required String updatedBy,
    String? note,
  }) async {
    try {
      final incidentRef = _incidentsCollection.doc(incidentId);

      final historyRef = incidentRef.collection('statusHistory').doc();

      final batch = _firestore.batch();

      // Updating the incidents current status
      batch.update(incidentRef, {
        'status': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Record the status changes
      final historyEntry = StatusHistory(
        entryId: historyRef.id,
        status: newStatus,
        updatedBy: updatedBy,
        note: note,
        createdAt: DateTime.now(),
      );

      batch.set(historyRef, {
        ...historyEntry.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to update incident status: $e');
    }
  }

  // Retrieving all incidents for the dashboard home feed
  Stream<List<Incident>> getAllIncidents() {
    return _incidentsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Incident.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Retrieving incidents submitted by a particular student
  Stream<List<Incident>> getUserIncidents(String userId) {
    return _incidentsCollection
        .where('reporterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Incident.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // Retrieving a single incident using its document ID
  Future<Incident?> getIncidentById(String incidentId) async {
    try {
      final doc = await _incidentsCollection.doc(incidentId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return Incident.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to retrieve incident: $e');
    }
  }

  // Retrieving status history
  Stream<List<StatusHistory>> getStatusHistory(String incidentId) {
    return _firestore
        .collection('incidents')
        .doc(incidentId)
        .collection('statusHistory')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return StatusHistory.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
