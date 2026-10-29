import 'package:campus_reporting_app/enum/incident_status_enum.dart';

class StatusHistory {
  final String entryId;
  final IncidentStatusEnum status;
  final String updatedBy;
  final String? note;
  final DateTime createdAt;

  const StatusHistory({
    required this.entryId,
    required this.status,
    required this.updatedBy,
    required this.note,
    required this.createdAt,
  });

  // Receiving data from Firestone or API and converting raw map to Dart object
  factory StatusHistory.fromMap(Map<String, dynamic> map, String entryId) {
    return StatusHistory(
      entryId: entryId,
      status: IncidentStatusEnum.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => IncidentStatusEnum.submitted,
      ),
      updatedBy: map['updatedBy'] as String,
      note: map['note'] as String?,
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  // Sending or saving data back to firebase, converting Dart object to raw map
  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'updatedBy': updatedBy,
      'note': note,
      'createdAt': createdAt,
    };
  }
}
