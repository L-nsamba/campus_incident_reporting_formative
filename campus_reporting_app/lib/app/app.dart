import 'package:campus_reporting_app/app/router/app_router.dart';
import 'package:campus_reporting_app/app/router/auth_gate.dart';
import 'package:campus_reporting_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CampusIncidentApp extends StatefulWidget {
  const CampusIncidentApp({super.key});

  @override
  State<CampusIncidentApp> createState() => _CampusIncidentAppState();
}

class _CampusIncidentAppState extends State<CampusIncidentApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Incident Reporting',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      home: const AuthGate(),

      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
