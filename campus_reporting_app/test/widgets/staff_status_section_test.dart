import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/models/status_history.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/repositories/incident_repository.dart';
import 'package:campus_reporting_app/widgets/staff/build_staff_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Fake repository: no Firebase connection required.
class FakeIncidentRepository implements IncidentRepository {
  @override
  Future<String> createIncident(Incident incident) async {
    return 'test-incident-id';
  }

  @override
  Future<Incident?> getIncidentById(String incidentId) async {
    return null;
  }

  @override
  Stream<List<Incident>> getAllIncidents() {
    return Stream.value([]);
  }

  @override
  Stream<List<Incident>> getUserIncidents(String userId) {
    return Stream.value([]);
  }

  @override
  Stream<List<StatusHistory>> getStatusHistory(String incidentId) {
    return Stream.value([]);
  }

  @override
  Future<void> updateIncidentStatus({
    required String incidentId,
    required IncidentStatusEnum newStatus,
    required String updatedBy,
    String? note,
  }) async {}
}

void main() {
  late IncidentProvider incidentProvider;

  setUp(() {
    incidentProvider = IncidentProvider(FakeIncidentRepository());
  });

  tearDown(() {
    incidentProvider.dispose();
  });

  final testIncident = Incident(
    id: 'incident-001',
    reporterId: 'student-001',
    title: 'Broken classroom chair',
    description: 'A chair is damaged.',
    category: IncidentCategoryEnum.furniture,
    location: 'Classroom 2',
    status: IncidentStatusEnum.submitted,
    createdAt: DateTime(2026, 11, 7),
  );

  Widget createTestWidget({
    required Incident incident,
    required Future<void> Function(IncidentStatusEnum status, String note)
    onUpdate,
  }) {
    return ChangeNotifierProvider<IncidentProvider>.value(
      value: incidentProvider,
      child: MaterialApp(
        home: Scaffold(
          body: StaffStatusSection(incident: incident, onUpdate: onUpdate),
        ),
      ),
    );
  }

  group('StaffStatusSection Widget Tests', () {
    testWidgets('displays current and next incident status', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          incident: testIncident,
          onUpdate: (status, note) async {},
        ),
      );

      expect(find.text('Manage Report Status'), findsOneWidget);
      expect(find.text('Current Status'), findsOneWidget);
      expect(find.text('Next Status'), findsOneWidget);
      expect(find.text('In Review'), findsOneWidget);
      expect(find.text('Update Status'), findsOneWidget);
    });

    testWidgets('calls update callback with correct status and note', (
      tester,
    ) async {
      IncidentStatusEnum? receivedStatus;
      String? receivedNote;

      await tester.pumpWidget(
        createTestWidget(
          incident: testIncident,
          onUpdate: (status, note) async {
            receivedStatus = status;
            receivedNote = note;
          },
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Repair has been assigned.',
      );

      await tester.tap(find.text('Update Status'));
      await tester.pumpAndSettle();

      expect(receivedStatus, IncidentStatusEnum.inReview);
      expect(receivedNote, 'Repair has been assigned.');
    });

    testWidgets('does not offer another transition when resolved', (
      tester,
    ) async {
      final resolvedIncident = Incident(
        id: 'incident-002',
        reporterId: 'student-001',
        title: 'Repaired classroom chair',
        description: 'The chair has been repaired.',
        category: IncidentCategoryEnum.furniture,
        location: 'Classroom 2',
        status: IncidentStatusEnum.resolved,
        createdAt: DateTime(2026, 11, 7),
      );

      await tester.pumpWidget(
        createTestWidget(
          incident: resolvedIncident,
          onUpdate: (status, note) async {},
        ),
      );

      expect(
        find.text('No further status transitions available.'),
        findsOneWidget,
      );

      expect(find.text('Update Status'), findsNothing);
      expect(find.byType(TextField), findsNothing);
    });
  });
}
