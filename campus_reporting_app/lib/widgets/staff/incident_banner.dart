import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class IncidentBanner extends StatelessWidget {
  final VoidCallback onDashboardPressed;
  const IncidentBanner({super.key, required this.onDashboardPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay on top of campus reports.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review incident activity and track campus issues.',
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onDashboardPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('View all reports'),
          ),
        ],
      ),
    );
  }
}
