import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/widgets/shared/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _isResending = false;
  String? _message;
  String? _errorMessage;

  // Verification validity
  Future<void> _checkVerification() async {
    setState(() {
      _isChecking = true;
      _message = null;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();

      // Reloading the Firebase user and refreshing the profile
      await authProvider.refreshUser();

      if (!mounted) return;

      if (authProvider.isEmailVerified) {
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        setState(() {
          _message =
              'Your email has not been verified yet.'
              'Please check your inbox and try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  // Verification resending
  Future<void> _resendVerification() async {
    setState(() {
      _isResending = true;
      _message = null;
      _errorMessage = null;
    });

    try {
      await context.read<AuthProvider>().resendVerificationEmail();

      if (!mounted) return;

      setState(() {
        _message = 'Verification email sent. Please check your inbox';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email =
        context.watch<AuthProvider>().firebaseUser?.email ??
        'your registered email address';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 50),

              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 55,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Verify your email',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'We have sent a verification link to: ',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Text(
                'Open the email and follow the verification link.'
                'Once you have verified your email address, return here'
                'and select the button below.',

                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              if (_message != null) ...[
                Text(
                  _message!,
                  style: const TextStyle(color: AppColors.success),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              PrimaryButton(
                label: 'I have verified my email',
                isLoading: _isChecking,
                onPressed: _checkVerification,
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _isResending ? null : _resendVerification,
                child: _isResending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Resend verification email'),
              ),

              const SizedBox(height: 24),

              Text(
                'Did not receive the email? Check spam folder'
                'or try resending it.',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
