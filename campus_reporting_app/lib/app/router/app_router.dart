import 'package:campus_reporting_app/app/router/route_names.dart';
import 'package:campus_reporting_app/screens/auth/email_verification_screen.dart';
import 'package:campus_reporting_app/screens/auth/forgot_password_screen.dart';
import 'package:campus_reporting_app/screens/auth/login_screen.dart';
import 'package:campus_reporting_app/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.emailVerification:
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationScreen(),
        );

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
