import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:campus_reporting_app/models/app_user.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/models/status_history.dart';
import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/repositories/user_repository.dart';
import 'package:campus_reporting_app/widgets/shared/status_badge.dart';
import 'package:campus_reporting_app/widgets/shared/status_history_timeline.dart';
import 'package:campus_reporting_app/widgets/staff/build_staff_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncidentDetailsScreen extends StatefulWidget {
  final String incidentId;

  const IncidentDetailsScreen({super.key, required this.incidentId});

  @override
  State<IncidentDetailsScreen> createState() => _IncidentDetailsScreenState();
}

class _IncidentDetailsScreenState extends State<IncidentDetailsScreen> {
  late Future<Incident?> _incidentFuture;

  Future<AppUser?>? _reporterFuture;

  Stream<List<StatusHistory>>? _historyStream;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _historyStream ??= context.read<IncidentProvider>().getStatusHistory(
      widget.incidentId,
    );

    if (_reporterFuture == null) {
      final incidentProvider = context.read<IncidentProvider>();
      final userRepository = context.read<UserRepository>();

      _reporterFuture = _loadReporter(incidentProvider, userRepository);
    }
  }

  Future<AppUser?> _loadReporter(
    IncidentProvider incidentProvider,
    UserRepository userRepository,
  ) async {
    final incident = await incidentProvider.getIncidentById(widget.incidentId);

    if (incident == null) return null;

    return userRepository.getUserById(incident.reporterId);
  }

  Future<void> _updateStatus(
    Incident incident,
    IncidentStatusEnum status,
    String note,
  ) async {
    final authProvider = context.read<AuthProvider>();
    final incidentProvider = context.read<IncidentProvider>();

    final staffUid = authProvider.firebaseUser?.uid;

    if (staffUid == null) return;

    try {
      await incidentProvider.updateIncidentStatus(
        incidentId: incident.id,
        newStatus: status,
        updatedBy: staffUid,
        note: note.isEmpty ? null : note,
      );

      if (!mounted) return;

      setState(() {
        _incidentFuture = incidentProvider.getIncidentById(widget.incidentId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incident status updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _incidentFuture = context.read<IncidentProvider>().getIncidentById(
      widget.incidentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<Incident?>(
          future: _incidentFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 40,
                      color: AppColors.error,
                    ),

                    const SizedBox(height: 12),

                    const Text('Could not load incident details.'),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          _incidentFuture = context
                              .read<IncidentProvider>()
                              .getIncidentById(widget.incidentId);
                        });
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            final incident = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        incident.photoUrl != null &&
                            incident.photoUrl!.isNotEmpty
                        ? Image.network(
                            incident.photoUrl!,
                            width: double.infinity,
                            height: 190,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    incident.title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                incident.location,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      StatusBadge(status: incident.status),
                    ],
                  ),

                  const SizedBox(height: 14),

                  FutureBuilder<AppUser?>(
                    future: _reporterFuture,
                    builder: (context, snapshot) {
                      final reporterName =
                          snapshot.data?.name ?? 'Campus member';

                      return Text(
                        'Reported by: $reporterName',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Text(
                    incident.description.isNotEmpty
                        ? incident.description
                        : 'No description provided.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (context.read<AuthProvider>().isStaff) ...[
                    StaffStatusSection(
                      incident: incident,
                      onUpdate: (status, note) =>
                          _updateStatus(incident, status, note),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const Text(
                    'Status History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 18),

                  StreamBuilder<List<StatusHistory>>(
                    stream: _historyStream,
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Text('Unable to load status history');
                      }

                      return StatusHistoryTimeline(
                        history: snapshot.data ?? [],
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 190,
      color: AppColors.surface,
      child: const Icon(
        Icons.image_outlined,
        size: 45,
        color: AppColors.textSecondary,
      ),
    );
  }
}
