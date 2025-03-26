import 'package:get/get.dart';
import '../models/audit_model.dart';
import '../providers/audit_provider.dart';

class AuditService extends GetxService {
  final AuditProvider _provider = AuditProvider();

  // Basic CRUD operations
  Future<List<AuditModel>> getAllAuditEntries() => _provider.getAll();
  Future<AuditModel?> getAuditEntryById(int id) => _provider.getById(id);
  Future<AuditModel> createAuditEntry(AuditModel audit) =>
      _provider.create(audit);

  // Specific operations
  Future<List<AuditModel>> getAuditEntriesByUser(int userId) =>
      _provider.getByUser(userId);
  Future<List<AuditModel>> getAuditEntriesByOperation(String operation) =>
      _provider.getByOperation(operation);
  Future<List<AuditModel>> getAuditEntriesByTable(String tableName) =>
      _provider.getByTable(tableName);
  Future<List<AuditModel>> getAuditEntriesByAffectedId(
          int affectedId, String tableName) =>
      _provider.getByAffectedId(affectedId, tableName);
  Future<List<AuditModel>> getAuditEntriesByDateRange(
          DateTime startDate, DateTime endDate) =>
      _provider.getByDateRange(startDate, endDate);

  // Business logic methods

  // Get a formatted description of changes
  String getChangeDescription(AuditModel audit) {
    switch (audit.operation) {
      case 'INSERT':
        return 'Created new ${audit.affectedTable} record (ID: ${audit.affectedId})';
      case 'UPDATE':
        return 'Updated ${audit.affectedTable} record (ID: ${audit.affectedId})';
      case 'DELETE':
        return 'Deleted ${audit.affectedTable} record (ID: ${audit.affectedId})';
      default:
        return 'Modified ${audit.affectedTable} record (ID: ${audit.affectedId})';
    }
  }

  // Get a list of changed fields
  List<String> getChangedFields(AuditModel audit) {
    if (audit.operation == 'INSERT' ||
        audit.operation == 'DELETE' ||
        audit.previousValues == null ||
        audit.newValues == null) {
      return [];
    }

    List<String> changedFields = [];
    audit.newValues!.forEach((key, value) {
      if (audit.previousValues!.containsKey(key) &&
          audit.previousValues![key] != value) {
        changedFields.add(key);
      }
    });

    return changedFields;
  }

  // Check if this is a critical change
  bool isCriticalChange(AuditModel audit) {
    // Define critical tables and fields
    const criticalTables = ['users', 'roles', 'permissions'];
    const criticalFields = ['state_id', 'role_id', 'is_admin'];

    if (criticalTables.contains(audit.affectedTable)) {
      return true;
    }

    if (audit.operation == 'DELETE') {
      return true;
    }

    final changedFields = getChangedFields(audit);
    for (final field in changedFields) {
      if (criticalFields.contains(field)) {
        return true;
      }
    }

    return false;
  }
}
