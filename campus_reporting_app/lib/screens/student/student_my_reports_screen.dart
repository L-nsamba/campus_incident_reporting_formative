import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/build_report.dart';
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

    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'You';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 28, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Reports',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Central place for all your report information',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: IncidentListView(
                  incidents: incidentProvider.myIncidents,
                  isLoading: incidentProvider.isLoadingMyIncidents,
                  hasError: incidentProvider.errorMessage != null,
                  onRetry: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      incidentProvider.listenToMyIncidents(user.uid);
                    }
                  },
                  reporterNameFor: (_) => userName,
                  emptyState: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 52,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No reports yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Your submitted incidents will appear here.',
                          style: TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
