import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show WatchContext;

class StaffStatusSection extends StatefulWidget {
  final Incident incident;
  final Future<void> Function(IncidentStatusEnum status, String note) onUpdate;

  const StaffStatusSection({
    super.key,
    required this.incident,
    required this.onUpdate,
  });

  @override
  State<StaffStatusSection> createState() => _StaffStatusSectionState();
}

class _StaffStatusSectionState extends State<StaffStatusSection> {
  final _noteController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void didUpdateWidget(StaffStatusSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.incident.status != widget.incident.status) {
      _noteController.clear();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nextStatuses = widget.incident.status.nextStatuses;

    if (nextStatuses.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await widget.onUpdate(nextStatuses.first, _noteController.text.trim());

      if (!mounted) return;

      _noteController.clear();
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextStatuses = widget.incident.status.nextStatuses;

    final isUpdating =
        context.watch<IncidentProvider>().isUpdatingStatus || _isSubmitting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Report Status',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Current Status',
            style: TextStyle(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 8),

          StatusBadge(status: widget.incident.status),

          const SizedBox(height: 18),

          if (nextStatuses.isNotEmpty) ...[
            const Text(
              'Next Status',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    nextStatuses.first.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Update Note (Optional)',
                hintText: 'Add information about this update...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUpdating ? null : _submit,
                child: isUpdating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Update Status'),
              ),
            ),
          ] else ...[
            const Text('No further status transitions available.'),
          ],
        ],
      ),
    );
  }
}
