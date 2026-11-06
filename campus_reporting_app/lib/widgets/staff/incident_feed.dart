import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/screens/student/incident_details_screen.dart';
import 'package:campus_reporting_app/utils/incident_filter.dart';
import 'package:campus_reporting_app/widgets/incident_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show WatchContext;

class IncidentFeed extends StatelessWidget {
  final IncidentCategoryEnum? category;
  final String searchQuery;
  final Widget emptyState;
  const IncidentFeed({
    super.key,
    this.category,
    required this.searchQuery,
    required this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();
    if (provider.isLoadingIncidents) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.cloud_off_outlined, size: 42),
              const SizedBox(height: 12),
              const Text(
                'Unable to load campus incidents.',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: provider.retryAllIncidents,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.incidents.isEmpty) return emptyState;

    final filteredIncidents = filterIncidents(
      provider.incidents,
      category: category,
      searchQuery: searchQuery,
    );

    if (filteredIncidents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No incidents match your search or category.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredIncidents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final incident = filteredIncidents[index];

        return IncidentCard(
          incident: incident,
          reporterName: 'Campus Member',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => IncidentDetailsScreen(incidentId: incident.id),
              ),
            );
          },
        );
      },
    );
  }
}
