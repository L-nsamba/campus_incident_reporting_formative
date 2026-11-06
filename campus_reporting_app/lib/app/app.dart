import 'package:campus_reporting_app/app/router/app_router.dart';
import 'package:campus_reporting_app/app/router/auth_gate.dart';
import 'package:campus_reporting_app/core/theme/app_theme.dart';
import 'package:campus_reporting_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampusIncidentApp extends StatefulWidget {
  const CampusIncidentApp({super.key});

  @override
  State<CampusIncidentApp> createState() => _CampusIncidentAppState();
}

class _CampusIncidentAppState extends State<CampusIncidentApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Campus Incident Reporting',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      home: const AuthGate(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
