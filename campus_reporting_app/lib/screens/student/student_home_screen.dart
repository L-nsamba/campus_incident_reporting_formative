import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/screens/student/incident_details_screen.dart';
import 'package:campus_reporting_app/utils/incident_filter.dart';
import 'package:campus_reporting_app/widgets/incident_card.dart';
import 'package:campus_reporting_app/widgets/student/category_filter_list.dart';
import 'package:campus_reporting_app/widgets/student/empty_incidents_state.dart';
import 'package:campus_reporting_app/widgets/student/incident_search_bar.dart';
import 'package:campus_reporting_app/widgets/student/report_banner.dart';
import 'package:campus_reporting_app/widgets/student/welcome_header.dart';
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

  Widget _buildIncidentFeed(IncidentProvider provider) {
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
                onPressed: () {
                  provider.retryAllIncidents();
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.incidents.isEmpty) {
      return EmptyIncidentsState(onReportPressed: widget.onSubmitPressed);
    }

    // Handling filtering and searching
    final filteredIncidents = filterIncidents(
      provider.incidents,
      category: _selectedCategory,
      searchQuery: _searchQuery,
    );

    if (filteredIncidents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No incidents match your search or category',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
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
      }),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemCount: filteredIncidents.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final incidentProvider = context.watch<IncidentProvider>();

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

              _buildIncidentFeed(incidentProvider),
            ],
          ),
        ),
      ),
    );
  }
}
