import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/screens/auth/email_verification_screen.dart';
import 'package:campus_reporting_app/screens/auth/login_screen.dart';
import 'package:campus_reporting_app/screens/staff/staff_navigation_screen.dart';
import 'package:campus_reporting_app/screens/student/student_navigation_screen.dart';
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

    // Verified user but profile not loaded
    if (authProvider.appUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                authProvider.errorMessage ??
                    'No profile found for this account.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => authProvider.logout(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      );
    }

    // The test dummy staff exempted from verification
    if (authProvider.isStaff) {
      return const StaffNavigationScreen();
    }

    // Students must verify their email
    if (authProvider.isStudent) {
      if (!authProvider.isEmailVerified) {
        return const EmailVerificationScreen();
      }

      return const StudentNavigationScreen();
    }

    return const Scaffold(
      body: Center(child: Text('Unable to determine your account role.')),
    );
  }
}
