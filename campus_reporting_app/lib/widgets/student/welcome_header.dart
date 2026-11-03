import 'package:campus_reporting_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String studentName;
  const WelcomeHeader({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, $studentName',
      style: AppTextStyles.heading.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
