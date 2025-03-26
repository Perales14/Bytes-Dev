import 'package:get/get.dart';
import '../models/specialty_model.dart';
import '../providers/specialty_provider.dart';

class SpecialtyService extends GetxService {
  final SpecialtyProvider _provider = SpecialtyProvider();

  // Basic CRUD operations
  Future<List<SpecialtyModel>> getAllSpecialties() => _provider.getAll();
  Future<SpecialtyModel?> getSpecialtyById(int id) => _provider.getById(id);
  Future<SpecialtyModel> createSpecialty(SpecialtyModel specialty) =>
      _provider.create(specialty);
  Future<SpecialtyModel> updateSpecialty(SpecialtyModel specialty) =>
      _provider.update(specialty);
  Future<void> deleteSpecialty(int id) => _provider.delete(id);

  // Specific operations
  Future<SpecialtyModel?> findSpecialtyByName(String name) =>
      _provider.findByName(name);
  Future<List<SpecialtyModel>> searchSpecialties(String term) =>
      _provider.findByTerm(term);

  // Business logic
  bool isValidSpecialtyName(String name) {
    return name.isNotEmpty && name.length >= 3;
  }

  // Get default specialty (for fallback)
  Future<SpecialtyModel> getDefaultSpecialty() async {
    final specialty = await findSpecialtyByName('General');
    if (specialty != null) {
      return specialty;
    }

    // Try to get any specialty
    final specialties = await getAllSpecialties();
    if (specialties.isNotEmpty) {
      return specialties.first;
    }

    // Return a placeholder if nothing exists
    return SpecialtyModel(
      id: 0,
      name: 'General',
      description: 'Default specialty',
    );
  }
}
