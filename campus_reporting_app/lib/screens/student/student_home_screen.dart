import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/incident_card.dart';
import 'package:campus_reporting_app/widgets/student/category_filter_list.dart';
import 'package:campus_reporting_app/widgets/student/empty_incidents_state.dart';
import 'package:campus_reporting_app/widgets/student/incident_search_bar.dart';
import 'package:campus_reporting_app/widgets/student/report_banner.dart';
import 'package:campus_reporting_app/widgets/student/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  IncidentCategoryEnum? _selectedCategory;
  // ignore: unused_field
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

  void _openSubmitTab() {}

  // Handling the searching and filtering
  List<Incident> _filterIncidents(List<Incident> incidents) {
    return incidents.where((incident) {
      final matchesCategory =
          _selectedCategory == null || incident.category == _selectedCategory;

      final query = _searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          incident.title.toLowerCase().contains(query) ||
          incident.description.toLowerCase().contains(query) ||
          incident.location.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
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
      return EmptyIncidentsState(onReportPressed: _openSubmitTab);
    }

    final filteredIncidents = _filterIncidents(provider.incidents);

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
          onTap: () {},
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

              ReportBanner(onReportPressed: _openSubmitTab),

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

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            _openSubmitTab();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Submit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: 'My Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
