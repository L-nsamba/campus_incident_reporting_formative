enum IncidentCategoryEnum {
  facilities,
  water,
  electricity,
  furniture,
  sanitation,
  safety,
  other,
}

extension IncidentCategoryX on IncidentCategoryEnum {
  String get label {
    switch (this) {
      case IncidentCategoryEnum.facilities:
        return 'Facilities';
      case IncidentCategoryEnum.water:
        return 'Water';
      case IncidentCategoryEnum.electricity:
        return 'Electricity';
      case IncidentCategoryEnum.furniture:
        return 'Furniture';
      case IncidentCategoryEnum.sanitation:
        return 'Sanitation';
      case IncidentCategoryEnum.safety:
        return 'Safety';
      case IncidentCategoryEnum.other:
        return 'Other';
    }
  }
}
