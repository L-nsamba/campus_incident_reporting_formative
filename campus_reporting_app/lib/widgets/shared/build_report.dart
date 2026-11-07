import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/screens/student/incident_details_screen.dart';
import 'package:campus_reporting_app/widgets/shared/incident_card.dart';
import 'package:flutter/material.dart';

class IncidentListView extends StatelessWidget {
  final List<Incident> incidents;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;
  final Widget emptyState;
  final String Function(Incident incident) reporterNameFor;
  final bool embedded; 

  const IncidentListView({
    super.key,
    required this.incidents,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
    required this.emptyState,
    required this.reporterNameFor,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.error),
            const SizedBox(height: 12),
            const Text('Could not load reports.'),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      );
    }

    if (incidents.isEmpty) return emptyState;

    return ListView.separated(
      shrinkWrap: embedded,
      physics: embedded ? const NeverScrollableScrollPhysics() : null,
      itemCount: incidents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final incident = incidents[index];
        return IncidentCard(
          incident: incident,
          reporterName: reporterNameFor(incident),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IncidentDetailsScreen(incidentId: incident.id),
            ),
          ),
        );
      },
    );
  }
}
