import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/staff/incident_banner.dart';
import 'package:campus_reporting_app/widgets/staff/incident_feed.dart';
import 'package:campus_reporting_app/widgets/student/category_filter_list.dart';
import 'package:campus_reporting_app/widgets/student/incident_search_bar.dart';
import 'package:campus_reporting_app/widgets/student/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffHomeScreen extends StatefulWidget {
  final VoidCallback onViewReportsPressed;
  const StaffHomeScreen({super.key, required this.onViewReportsPressed});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  IncidentCategoryEnum? _selectedCategory;
  String _searchQuery = '';

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
    final authProvider = context.watch<AuthProvider>();

    final staffName = authProvider.appUser?.name ?? 'Staff';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(studentName: staffName),

              const SizedBox(height: 20),

              IncidentBanner(onDashboardPressed: widget.onViewReportsPressed),

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
                'Recent campus reports',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 14),

              IncidentFeed(
                category: _selectedCategory,
                searchQuery: _searchQuery,
                emptyState: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined, size: 42),
                        SizedBox(height: 12),
                        Text('No campus reports yet.'),
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
