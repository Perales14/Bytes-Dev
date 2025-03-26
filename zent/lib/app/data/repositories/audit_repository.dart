import '../models/base_model.dart';
import '../models/audit_model.dart';
import 'base_repository.dart';

class AuditRepository extends BaseRepository<AuditModel> {
  AuditRepository() : super(tableName: 'audit');

  @override
  AuditModel fromMap(Map<String, dynamic> map) {
    return AuditModel(
      id: map['id'] ?? 0,
      affectedTable: map['affected_table'] ?? '',
      operation: map['operation'],
      affectedId: map['affected_id'],
      previousValues: map['previous_values'] != null
          ? Map<String, dynamic>.from(map['previous_values'])
          : null,
      newValues: map['new_values'] != null
          ? Map<String, dynamic>.from(map['new_values'])
          : null,
      userId: map['user_id'],
      createdAt: BaseModel.parseDateTime(map['created_at']),
    );
  }

  // Get audit entries by user
  Future<List<AuditModel>> getByUser(int userId) async {
    try {
      return await query('user_id = ?', [userId]);
    } catch (e) {
      throw Exception('Error getting audit entries by user: $e');
    }
  }

  // Get audit entries by operation type
  Future<List<AuditModel>> getByOperation(String operation) async {
    try {
      return await query('operation = ?', [operation]);
    } catch (e) {
      throw Exception('Error getting audit entries by operation: $e');
    }
  }

  // Get audit entries by affected table
  Future<List<AuditModel>> getByTable(String tableName) async {
    try {
      return await query('affected_table = ?', [tableName]);
    } catch (e) {
      throw Exception('Error getting audit entries by table: $e');
    }
  }

  // Get audit entries by affected ID and table
  Future<List<AuditModel>> getByAffectedId(
      int affectedId, String tableName) async {
    try {
      return await query(
          'affected_id = ? AND affected_table = ?', [affectedId, tableName]);
    } catch (e) {
      throw Exception('Error getting audit entries by affected ID: $e');
    }
  }

  // Get audit entries by date range
  Future<List<AuditModel>> getByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      return await query('created_at >= ? AND created_at <= ?', [
        BaseModel.formatDateTime(startDate),
        BaseModel.formatDateTime(endDate)
      ]);
    } catch (e) {
      throw Exception('Error getting audit entries by date range: $e');
    }
  }

  // Create with validation
  @override
  Future<AuditModel> create(AuditModel model) async {
    try {
      // Validate operation type
      if (model.operation != null &&
          !['INSERT', 'UPDATE', 'DELETE'].contains(model.operation)) {
        throw Exception('Invalid operation type');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating audit entry: $e');
    }
  }
}
