import 'package:campus_reporting_app/app/app.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/repositories/incident_repository.dart';
import 'package:campus_reporting_app/services/auth_service.dart';
import 'package:campus_reporting_app/services/cloudinary_service.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),

        // Incident dependencies
        Provider(create: (_) => IncidentRepository()),
        ChangeNotifierProvider(
          create: (context) =>
              IncidentProvider(context.read<IncidentRepository>()),
        ),

        // Cloudinary service
        Provider(create: (_) => CloudinaryService()),
      ],
      child: const CampusIncidentApp(),
    ),
  );
}
