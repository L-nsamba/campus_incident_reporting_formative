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
      debugShowCheckedModeBanner: false,
      title: 'Campus Incident Reporting',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Campus Reporting App'),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
