import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final String reporterName;
  final VoidCallback onTap;

  const IncidentCard({
    super.key,
    required this.incident,
    required this.reporterName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child:
                    incident.phototUrl != null && incident.phototUrl!.isNotEmpty
                    ? Image.network(
                        incident.phototUrl!,
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return _imagePlaceholder();
                        },

                        errorBuilder: (_, _, _) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 5),
                    Text(
                      reporterName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            incident.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),
                    StatusBadge(status: incident.status),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Image.asset(
      'assets/images/incident_placeholder.jpg',
      width: 76,
      height: 76,
      fit: BoxFit.cover,
    );
  }
}
