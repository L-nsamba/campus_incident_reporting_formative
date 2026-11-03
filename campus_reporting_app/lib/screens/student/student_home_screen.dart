import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
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

  void _openSubmitTab() {}

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

              EmptyIncidentsState(onReportPressed: _openSubmitTab),
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
