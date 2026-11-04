import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';

class Incident {
  final String id;
  final String reporterId; // user.userid
  final String title;
  final String description;
  final IncidentCategoryEnum category;
  final String location; // Stores the final specific location entered
  final String? photoUrl;
  final IncidentStatusEnum status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Incident({
    required this.id,
    required this.reporterId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.photoUrl,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  // Receiving data from Firestone or API and converting raw map to Dart object
  factory Incident.fromMap(Map<String, dynamic> map, String id) {
    return Incident(
      id: id,
      reporterId: map['reporterId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: IncidentCategoryEnum.values.firstWhere(
        (category) => category.name == map['category'],
        orElse: () => IncidentCategoryEnum.other,
      ),
      location: map['location'] as String,
      photoUrl: map['photoUrl'] as String?,
      status: IncidentStatusEnum.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => IncidentStatusEnum.submitted,
      ),
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: map['updatedAt'] == null
          ? null
          : (map['updatedAt'] as dynamic).toDate(),
    );
  }

  // Sending or saving data back to firebase, converting Dart object to raw map
  Map<String, dynamic> toMap() {
    return {
      'reporterId': reporterId,
      'title': title,
      'description': description,
      'category': category.name,
      'location': location,
      'photoUrl': photoUrl,
      'status': status.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
