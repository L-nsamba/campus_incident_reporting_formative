import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final IncidentStatusEnum status;

  const StatusBadge({super.key, required this.status});

  Color get statusColor {
    switch (status) {
      case IncidentStatusEnum.submitted:
        return AppColors.submitted;
      case IncidentStatusEnum.inReview:
        return AppColors.inReview;
      case IncidentStatusEnum.inProgress:
        return AppColors.inProgress;
      case IncidentStatusEnum.resolved:
        return AppColors.resolved;
    }
  }

  String get statusLabel {
    switch (status) {
      case IncidentStatusEnum.submitted:
        return 'Submitted';
      case IncidentStatusEnum.inReview:
        return 'In Review';
      case IncidentStatusEnum.inProgress:
        return 'In Progress';
      case IncidentStatusEnum.resolved:
        return 'Resolved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusLabel,
        style: TextStyle(
          color: statusColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
