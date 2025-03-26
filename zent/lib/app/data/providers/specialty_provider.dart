import '../models/specialty_model.dart';
import '../repositories/specialty_repository.dart';

class SpecialtyProvider {
  final SpecialtyRepository _repository = SpecialtyRepository();

  // Basic CRUD operations
  Future<List<SpecialtyModel>> getAll() => _repository.getAll();
  Future<SpecialtyModel?> getById(int id) => _repository.getById(id);
  Future<SpecialtyModel> create(SpecialtyModel specialty) =>
      _repository.create(specialty);
  Future<SpecialtyModel> update(SpecialtyModel specialty) =>
      _repository.update(specialty);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<SpecialtyModel?> findByName(String name) =>
      _repository.findByName(name);
  Future<List<SpecialtyModel>> findByTerm(String term) =>
      _repository.findByTerm(term);
}
