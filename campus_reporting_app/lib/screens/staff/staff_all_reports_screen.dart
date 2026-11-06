import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/build_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffAllReportsScreen extends StatefulWidget {
  const StaffAllReportsScreen({super.key});

  @override
  State<StaffAllReportsScreen> createState() => _StaffAllReportsScreenState();
}

class _StaffAllReportsScreenState extends State<StaffAllReportsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<IncidentProvider>().listenToAllIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final incidentProvider = context.watch<IncidentProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 28, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Reports',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Manage and monitor all campus incidents',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: IncidentListView(
                  incidents: incidentProvider.incidents,
                  isLoading: incidentProvider.isLoadingIncidents,
                  hasError: incidentProvider.errorMessage != null,
                  onRetry: () {
                    incidentProvider.retryAllIncidents();
                  },
                  reporterNameFor: (_) => 'Campus Member',
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
                          'No campus reports yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),

                        Text(
                          'Newly submitted incidents will appear here.',
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
