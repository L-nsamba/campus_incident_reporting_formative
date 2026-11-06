enum IncidentStatusEnum { submitted, inReview, inProgress, resolved }

extension StatusLabelX on IncidentStatusEnum {
  String get label {
    switch (this) {
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

  // Statuses a staff member can move this report to next.
  List<IncidentStatusEnum> get nextStatuses {
    switch (this) {
      case IncidentStatusEnum.submitted:
        return [IncidentStatusEnum.inReview];

      case IncidentStatusEnum.inReview:
        return [IncidentStatusEnum.inProgress];

      case IncidentStatusEnum.inProgress:
        return [IncidentStatusEnum.resolved];

      case IncidentStatusEnum.resolved:
        return [];
    }
  }
}
