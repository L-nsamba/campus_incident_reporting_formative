import 'package:campus_reporting_app/screens/staff/staff_dashboard_screen.dart';
import 'package:campus_reporting_app/screens/staff/staff_home_screen.dart';
import 'package:campus_reporting_app/screens/staff/staff_profile_screen.dart';
import 'package:flutter/material.dart';

class StaffNavigationScreen extends StatefulWidget {
  const StaffNavigationScreen({super.key});

  @override
  State<StaffNavigationScreen> createState() => _StaffNavigationScreenState();
}

class _StaffNavigationScreenState extends State<StaffNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    StaffHomeScreen(
      onDashboardPressed: () {
        setState(() => _currentIndex = 1);
      },
    ),
    const StaffDashboardScreen(),
    const StaffProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black,
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
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
