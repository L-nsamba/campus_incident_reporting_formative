import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyIncidentsState extends StatelessWidget {
  final VoidCallback onReportPressed;
  const EmptyIncidentsState({super.key, required this.onReportPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'No reports yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            const Text(
              'There are currently no campus incidents '
              'to display. Be the first to report an issue! ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            TextButton(
              onPressed: onReportPressed,
              child: const Text(
                'Report an Issue',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
