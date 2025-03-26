import 'package:get/get.dart';
import '../models/incident_model.dart';
import '../providers/incident_provider.dart';

class IncidentService extends GetxService {
  final IncidentProvider _provider = IncidentProvider();

  // Basic CRUD operations
  Future<List<IncidentModel>> getAllIncidents() => _provider.getAll();
  Future<IncidentModel?> getIncidentById(int id) => _provider.getById(id);
  Future<IncidentModel> createIncident(IncidentModel incident) =>
      _provider.create(incident);
  Future<IncidentModel> updateIncident(IncidentModel incident) =>
      _provider.update(incident);
  Future<void> deleteIncident(int id) => _provider.delete(id);

  // Specific operations
  Future<List<IncidentModel>> getIncidentsByProject(int projectId) =>
      _provider.getByProject(projectId);
  Future<List<IncidentModel>> getIncidentsByType(int incidentTypeId) =>
      _provider.getByIncidentType(incidentTypeId);
  Future<List<IncidentModel>> getIncidentsByImpactLevel(String impactLevel) =>
      _provider.getByImpactLevel(impactLevel);
  Future<List<IncidentModel>> searchIncidentsByDescription(
          String description) =>
      _provider.searchByDescription(description);

  // Business logic methods
  bool isValidImpactLevel(String? impactLevel) {
    return impactLevel == null ||
        ['Low', 'Medium', 'High'].contains(impactLevel);
  }

  // Get color for impact level
  String getImpactLevelColor(String? impactLevel) {
    switch (impactLevel) {
      case 'Low':
        return '#4CAF50'; // Green
      case 'Medium':
        return '#FFC107'; // Amber
      case 'High':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey for undefined
    }
  }

  // Check if incident is critical
  bool isCriticalIncident(IncidentModel incident) {
    return incident.impactLevel == 'High';
  }
}
