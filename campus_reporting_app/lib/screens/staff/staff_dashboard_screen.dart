import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/build_report.dart';
import 'package:campus_reporting_app/widgets/staff/daily_reports_chart.dart';
import 'package:campus_reporting_app/widgets/staff/report_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<IncidentProvider>().listenToAllIncidents();
    });
  }

  // Calculating the number of incidents in each status
  int _countByStatus(List<Incident> incidents, IncidentStatusEnum status) {
    return incidents.where((incident) => incident.status == status).length;
  }

  // Calculating reports submitted during the last seven days
  List<int> _getDailyReportCounts(List<Incident> incidents) {
    final now = DateTime.now();
    // Monday of the current week.
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    // Start from monday ending on sunday hence returning a list of 7 integers
    return List.generate(7, (index) {
      final day = monday.add(Duration(days: index));

      // For each day filtering the incident list by comparing creation date
      return incidents.where((incident) {
        final createdAt = incident.createdAt.toLocal();

        return createdAt.year == day.year &&
            createdAt.month == day.month &&
            createdAt.day == day.day;
      }).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();
    final incidents = provider.incidents;

    // Construction of the data to be in the stat cards
    final submittedCount = _countByStatus(
      incidents,
      IncidentStatusEnum.submitted,
    );

    final inReviewCount = _countByStatus(
      incidents,
      IncidentStatusEnum.inReview,
    );

    final inProgressCount = _countByStatus(
      incidents,
      IncidentStatusEnum.inProgress,
    );

    final resolvedCount = _countByStatus(
      incidents,
      IncidentStatusEnum.resolved,
    );

    final dailyCounts = _getDailyReportCounts(incidents);

    // Getting the three most recent incidents
    final latestReports = incidents.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: provider.isLoadingIncidents
            ? const Center(child: CircularProgressIndicator())
            : provider.incidentsError != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Unable to load dashboard data.'),
                    TextButton(
                      onPressed: provider.retryAllIncidents,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Staff Dashboard',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      'Key insights and analytics',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Summary cards
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.1,
                      children: [
                        ReportSummaryCard(
                          title: 'Submitted',
                          count: submittedCount,
                        ),
                        ReportSummaryCard(
                          title: 'In Review',
                          count: inReviewCount,
                        ),
                        ReportSummaryCard(
                          title: 'In Progress',
                          count: inProgressCount,
                        ),
                        ReportSummaryCard(
                          title: 'Resolved',
                          count: resolvedCount,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Daily reports chart
                    DailyReportsChart(dailyCounts: dailyCounts),

                    const SizedBox(height: 22),

                    // Latest reports
                    const Text(
                      'Latest Reports',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (latestReports.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No reports available yet.'),
                        ),
                      )
                    else
                      IncidentListView(
                        incidents: latestReports,
                        isLoading: false,
                        hasError: false,
                        onRetry: () {},
                        reporterNameFor: (_) => 'Campus Member',
                        emptyState: const SizedBox.shrink(),
                        embedded: true,
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
