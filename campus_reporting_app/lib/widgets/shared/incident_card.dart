import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/widgets/shared/status_badge.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      elevation: 1,
      color: colorScheme.surface,
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
                    incident.photoUrl != null && incident.photoUrl!.isNotEmpty
                    ? Image.network(
                        incident.photoUrl!,
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      reporterName,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            incident.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
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

              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorScheme.onSurfaceVariant,
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
