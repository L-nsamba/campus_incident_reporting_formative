import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/utils/validators.dart';
import 'package:campus_reporting_app/widgets/custom_text_field.dart';
import 'package:campus_reporting_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await context.read<AuthProvider>().sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _emailSent = success;

      if (!success) {
        _errorMessage =
            context.read<AuthProvider>().errorMessage ??
            'Unable to send reset email. Please try again.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_outlined,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  _emailSent ? 'Check Your Email' : 'Reset Your Password',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 12),

                Text(
                  _emailSent
                      ? 'If an account exists for this email,'
                            'a password reset link will be sent.'
                            'Check your inbox.'
                      : 'Enter the email address associated with'
                            'your account and we will send you a '
                            'password reset link',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 32),

                if (!_emailSent) ...[
                  CustomTextField(
                    label: 'Email Address',
                    hintText: 'Enter your registered email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.validateLoginEmail,
                  ),

                  const SizedBox(height: 24),

                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: 16),
                  ],

                  PrimaryButton(
                    label: 'Send Reset Link',
                    isLoading: _isLoading,
                    onPressed: _sendResetEmail,
                  ),
                ] else ...[
                  Center(
                    child: Text(
                      _emailController.text.trim(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: 'Back to Login',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _emailSent = false;
                          _errorMessage = null;
                        });
                      },
                      child: const Text('Try another email'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
