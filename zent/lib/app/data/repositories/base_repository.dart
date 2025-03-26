import '../models/base_model.dart';
import '../utils/database_helper.dart';

abstract class BaseRepository<T extends BaseModel> {
  final String tableName;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  BaseRepository({required this.tableName});

  // Abstract method to create object from map
  T fromMap(Map<String, dynamic> map);

  // Get all entities
  Future<List<T>> getAll() async {
    try {
      final result = await _dbHelper.getAll(tableName);
      return result.map((map) => fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error getting all records from $tableName: $e');
    }
  }

  // Get entity by ID
  Future<T?> getById(int id) async {
    try {
      final result = await _dbHelper.getById(tableName, id);
      return result != null ? fromMap(result) : null;
    } catch (e) {
      throw Exception('Error getting record by id from $tableName: $e');
    }
  }

  // Create new entity
  Future<T> create(T model) async {
    try {
      model.createdAt = DateTime.now();
      model.updatedAt = DateTime.now();

      final result = await _dbHelper.insert(tableName, model.toMap());
      return fromMap(result);
    } catch (e) {
      throw Exception('Error creating record in $tableName: $e');
    }
  }

  // Update existing entity
  Future<T> update(T model) async {
    try {
      model.updateModifiedAt();

      await _dbHelper.update(
        tableName,
        model.toMap(),
        'id = ?',
        [model.id],
      );
      return model;
    } catch (e) {
      throw Exception('Error updating record in $tableName: $e');
    }
  }

  // Delete entity by id
  Future<void> delete(int id) async {
    try {
      await _dbHelper.delete(
        tableName,
        'id = ?',
        [id],
      );
    } catch (e) {
      throw Exception('Error deleting record from $tableName: $e');
    }
  }

  // Custom query with where clause
  Future<List<T>> query(String whereClause, List<dynamic> whereArgs) async {
    try {
      final result = await _dbHelper.query(
        tableName,
        whereClause,
        whereArgs,
      );
      return result.map((map) => fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error querying $tableName: $e');
    }
  }

  // Set sent status
  Future<void> markAsSent(int id) async {
    try {
      await _dbHelper.update(
        tableName,
        {'enviado': 1},
        'id = ?',
        [id],
      );
    } catch (e) {
      throw Exception('Error marking record as sent in $tableName: $e');
    }
  }

  // Get unsent records
  Future<List<T>> getUnsent() async {
    try {
      return await query('enviado = ?', [0]);
    } catch (e) {
      throw Exception('Error getting unsent records from $tableName: $e');
    }
  }
}
