import '../models/base_model.dart';
import '../models/state_model.dart';
import 'base_repository.dart';

class StateRepository extends BaseRepository<StateModel> {
  StateRepository() : super(tableName: 'states');

  @override
  StateModel fromMap(Map<String, dynamic> map) {
    return StateModel(
      id: map['id'] ?? 0,
      tableName: map['table_name'] ?? '',
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get states by table name
  Future<List<StateModel>> getByTableName(String tableName) async {
    try {
      return await query('table_name = ?', [tableName]);
    } catch (e) {
      throw Exception('Error getting states by table name: $e');
    }
  }

  // Find state by code
  Future<StateModel?> findByCode(String code) async {
    try {
      final results = await query('code = ?', [code]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding state by code: $e');
    }
  }

  // Find state by name and table name
  Future<StateModel?> findByNameAndTable(String name, String tableName) async {
    try {
      final results =
          await query('name = ? AND table_name = ?', [name, tableName]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding state by name and table: $e');
    }
  }

  // Find state by code and table name
  Future<StateModel?> findByCodeAndTable(String code, String tableName) async {
    try {
      final results =
          await query('code = ? AND table_name = ?', [code, tableName]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding state by code and table: $e');
    }
  }

  // Create with validation
  @override
  Future<StateModel> create(StateModel model) async {
    try {
      // Check for duplicate table/code combination
      final existingState =
          await findByCodeAndTable(model.code, model.tableName);
      if (existingState != null) {
        throw Exception(
            'A state with this code already exists for the specified table');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating state: $e');
    }
  }

  // Update with validation
  @override
  Future<StateModel> update(StateModel model) async {
    try {
      // Check for duplicate table/code, excluding this state's id
      final results = await query('code = ? AND table_name = ? AND id != ?',
          [model.code, model.tableName, model.id]);

      if (results.isNotEmpty) {
        throw Exception(
            'Another state with this code already exists for the specified table');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error updating state: $e');
    }
  }
}
