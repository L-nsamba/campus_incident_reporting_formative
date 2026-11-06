import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';

List<Incident> filterIncidents(
  List<Incident> incidents, {
  IncidentCategoryEnum? category,
  String searchQuery = '',
}) {
  final query = searchQuery.trim().toLowerCase();

  return incidents.where((incident) {
    final matchesCategory = category == null || incident.category == category;

    final matchesSearch =
        query.isEmpty ||
        incident.title.toLowerCase().contains(query) ||
        incident.description.toLowerCase().contains(query) ||
        incident.location.toLowerCase().contains(query);

    return matchesCategory && matchesSearch;
  }).toList();
}
