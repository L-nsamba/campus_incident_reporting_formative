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
}
