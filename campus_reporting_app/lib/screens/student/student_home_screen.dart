import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/shared/category_filter_list.dart';
import 'package:campus_reporting_app/widgets/shared/empty_incidents_state.dart';
import 'package:campus_reporting_app/widgets/shared/incident_search_bar.dart';
import 'package:campus_reporting_app/widgets/student/report_banner.dart';
import 'package:campus_reporting_app/widgets/student/report_feed.dart';
import 'package:campus_reporting_app/widgets/shared/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHomeScreen extends StatefulWidget {
  final VoidCallback onSubmitPressed;
  const StudentHomeScreen({super.key, required this.onSubmitPressed});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  IncidentCategoryEnum? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Starting listening to Firestone after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<IncidentProvider>().listenToAllIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final studentName = authProvider.appUser?.name ?? 'Student';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(studentName: studentName),

              const SizedBox(height: 20),

              ReportBanner(onReportPressed: widget.onSubmitPressed),
              const SizedBox(height: 18),

              IncidentSearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              CategoryFilterList(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Recent campus incidents',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              ReportFeed(
                category: _selectedCategory,
                searchQuery: _searchQuery,
                emptyState: EmptyIncidentsState(
                  onReportPressed: widget.onSubmitPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
