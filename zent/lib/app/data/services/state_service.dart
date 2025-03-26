import 'package:get/get.dart';
import '../models/state_model.dart';
import '../providers/state_provider.dart';

class StateService extends GetxService {
  final StateProvider _provider = StateProvider();

  // Basic CRUD operations
  Future<List<StateModel>> getAllStates() => _provider.getAll();
  Future<StateModel?> getStateById(int id) => _provider.getById(id);
  Future<StateModel> createState(StateModel state) => _provider.create(state);
  Future<StateModel> updateState(StateModel state) => _provider.update(state);
  Future<void> deleteState(int id) => _provider.delete(id);

  // Specific operations
  Future<List<StateModel>> getStatesByTable(String tableName) =>
      _provider.getByTableName(tableName);
  Future<StateModel?> findStateByCode(String code) =>
      _provider.findByCode(code);
  Future<StateModel?> findStateByNameAndTable(String name, String tableName) =>
      _provider.findByNameAndTable(name, tableName);
  Future<StateModel?> findStateByCodeAndTable(String code, String tableName) =>
      _provider.findByCodeAndTable(code, tableName);

  // Common status fetchers
  Future<int> getActiveStateId(String tableName) async {
    final state = await findStateByCodeAndTable('ACTIVE', tableName);
    return state?.id ?? 1;
  }

  Future<int> getInactiveStateId(String tableName) async {
    final state = await findStateByCodeAndTable('INACTIVE', tableName);
    return state?.id ?? 2;
  }

  Future<int> getPendingStateId(String tableName) async {
    final state = await findStateByCodeAndTable('PENDING', tableName);
    return state?.id ?? 3;
  }

  // Business logic methods
  bool isValidTableName(String tableName) {
    return tableName.isNotEmpty;
  }

  bool isValidStateCode(String code) {
    return code.isNotEmpty && code.length <= 20;
  }

  // Check if state is a system state (shouldn't be deleted)
  Future<bool> isSystemState(int id) async {
    final state = await getStateById(id);
    if (state == null) return false;

    // Common system states that shouldn't be deleted
    return ['ACTIVE', 'INACTIVE', 'PENDING', 'COMPLETED', 'CANCELED']
        .contains(state.code.toUpperCase());
  }
}
