import 'package:campus_reporting_app/screens/student/student_home_screen.dart';
import 'package:campus_reporting_app/screens/student/student_my_reports_screen.dart';
import 'package:campus_reporting_app/screens/student/student_profile_screen.dart';
import 'package:campus_reporting_app/screens/student/submit_incident_screen.dart';
import 'package:flutter/material.dart';

class StudentNavigationScreen extends StatefulWidget {
  final List<Widget>? testScreens;

  const StudentNavigationScreen({super.key, this.testScreens});

  @override
  State<StudentNavigationScreen> createState() =>
      _StudentNavigationScreenState();
}

class _StudentNavigationScreenState extends State<StudentNavigationScreen> {
  int _currentIndex = 0;

  void _openSubmitTab() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _onIncidentSubmitted() {
    setState(() {
      _currentIndex = 2;
    });
  }

  late final List<Widget> _screens =
  //  Introducing the widget.testScreens for navigation test for student pov
      widget.testScreens ??
      [
        StudentHomeScreen(onSubmitPressed: _openSubmitTab),
        SubmitIncidentScreen(onIncidentSubmitted: _onIncidentSubmitted),
        const StudentMyReportsScreen(),
        const StudentProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
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
