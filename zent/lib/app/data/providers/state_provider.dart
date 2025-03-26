import '../models/state_model.dart';
import '../repositories/state_repository.dart';

class StateProvider {
  final StateRepository _repository = StateRepository();

  // Basic CRUD operations
  Future<List<StateModel>> getAll() => _repository.getAll();
  Future<StateModel?> getById(int id) => _repository.getById(id);
  Future<StateModel> create(StateModel state) => _repository.create(state);
  Future<StateModel> update(StateModel state) => _repository.update(state);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<StateModel>> getByTableName(String tableName) =>
      _repository.getByTableName(tableName);
  Future<StateModel?> findByCode(String code) => _repository.findByCode(code);
  Future<StateModel?> findByNameAndTable(String name, String tableName) =>
      _repository.findByNameAndTable(name, tableName);
  Future<StateModel?> findByCodeAndTable(String code, String tableName) =>
      _repository.findByCodeAndTable(code, tableName);
}
