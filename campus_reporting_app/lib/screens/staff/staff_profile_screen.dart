import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ReadContext;

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();
          },
          child: ElevatedButton(
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            child: const Text('Toggle Theme'),
          ),
        ),
      ),
    );
  }
}
