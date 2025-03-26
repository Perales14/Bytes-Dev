import 'package:get/get.dart';
import '../models/incident_type_model.dart';
import '../providers/incident_type_provider.dart';

class IncidentTypeService extends GetxService {
  final IncidentTypeProvider _provider = IncidentTypeProvider();

  // Basic CRUD operations
  Future<List<IncidentTypeModel>> getAllIncidentTypes() => _provider.getAll();
  Future<IncidentTypeModel?> getIncidentTypeById(int id) =>
      _provider.getById(id);
  Future<IncidentTypeModel> createIncidentType(
          IncidentTypeModel incidentType) =>
      _provider.create(incidentType);
  Future<IncidentTypeModel> updateIncidentType(
          IncidentTypeModel incidentType) =>
      _provider.update(incidentType);
  Future<void> deleteIncidentType(int id) => _provider.delete(id);

  // Specific operations
  Future<IncidentTypeModel?> findIncidentTypeByName(String name) =>
      _provider.findByName(name);
  Future<List<IncidentTypeModel>> searchIncidentTypes(String searchTerm) =>
      _provider.searchIncidentTypes(searchTerm);

  // Business logic
  bool isValidIncidentTypeName(String name) {
    return name.isNotEmpty && name.length >= 3;
  }

  // Get default incident type (for fallback)
  Future<IncidentTypeModel> getDefaultIncidentType() async {
    final incidentType = await findIncidentTypeByName('General');
    if (incidentType != null) {
      return incidentType;
    }

    // Try to get any incident type
    final incidentTypes = await getAllIncidentTypes();
    if (incidentTypes.isNotEmpty) {
      return incidentTypes.first;
    }

    // Return a placeholder if nothing exists
    return IncidentTypeModel(
      id: 0,
      name: 'General',
      description: 'Default incident type',
    );
  }
}
