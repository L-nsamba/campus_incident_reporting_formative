import 'package:campus_reporting_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('displays login screen elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Welcome heading
      expect(find.text('Welcome Back'), findsOneWidget);

      // Supporting text
      expect(
        find.text('Sign in to report and track campus incidents.'),
        findsOneWidget,
      );

      // Form fields
      expect(find.text('ALU Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Login button
      expect(find.text('Login'), findsOneWidget);

      // Account registration link
      expect(find.text('Create Account'), findsOneWidget);

      // Forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('contains two text input fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}
