import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/screens/auth/email_verification_screen.dart';
import 'package:campus_reporting_app/screens/auth/login_screen.dart';
import 'package:campus_reporting_app/screens/staff/staff_home_screen.dart';
import 'package:campus_reporting_app/screens/student/student_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Waiting while the authentication state is being determined
    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // No signed in Firebase user
    if (authProvider.firebaseUser == null) {
      return const LoginScreen();
    }

    // Signed in but email has not been verified
    if (!authProvider.isEmailVerified) {
      return const EmailVerificationScreen();
    }

    // Verified user but profile not loaded
    if (authProvider.appUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Direct the user according to their Firestone role
    if (authProvider.isStudent) {
      return const StudentHomeScreen();
    }

    if (authProvider.isStaff) {
      return const StaffHomeScreen();
    }

    return const Scaffold(
      body: Center(child: Text('Unable to determine your account role.')),
    );
  }
}
