import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/screens/student/incident_details_screen.dart';
import 'package:campus_reporting_app/widgets/incident_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentMyReportsScreen extends StatefulWidget {
  const StudentMyReportsScreen({super.key});

  @override
  State<StudentMyReportsScreen> createState() => _StudentMyReportsScreenState();
}

class _StudentMyReportsScreenState extends State<StudentMyReportsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        context.read<IncidentProvider>().listenToMyIncidents(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final incidentProvider = context.watch<IncidentProvider>();

    final incidents = incidentProvider.myIncidents;

    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'You';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 28, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Reports',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Central place for all your report information',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: _buildReportsContent(
                  incidentProvider,
                  incidents,
                  userName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsContent(
    IncidentProvider provider,
    List<Incident> incidents,
    String userName,
  ) {
    if (provider.isLoadingMyIncidents) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.error),

            const SizedBox(height: 12),
            const Text('Could not load your reports.'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  provider.listenToMyIncidents(user.uid);
                }
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (incidents.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 52,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            const Text(
              'No reports yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your submitted incidents will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: incidents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final incident = incidents[index];

        return IncidentCard(
          incident: incident,
          reporterName: userName,
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
