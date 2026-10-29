enum CampusLocationEnum {
  library,
  classroom,
  studentResidence,
  cafeteria,
  washroom,
  compound,
  other,
}

extension CampusLocationExtension on CampusLocationEnum {
  String get label {
    switch (this) {
      case CampusLocationEnum.library:
        return 'Library';
      case CampusLocationEnum.classroom:
        return 'Classroom';
      case CampusLocationEnum.studentResidence:
        return 'Student Residence';
      case CampusLocationEnum.cafeteria:
        return 'Cafeteria';
      case CampusLocationEnum.washroom:
        return 'Washroom';
      case CampusLocationEnum.compound:
        return 'Compund';
      case CampusLocationEnum.other:
        return 'Other Location';
    }
  }
}
