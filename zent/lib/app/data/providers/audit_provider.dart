import '../models/audit_model.dart';
import '../repositories/audit_repository.dart';

class AuditProvider {
  final AuditRepository _repository = AuditRepository();

  // Basic CRUD operations
  Future<List<AuditModel>> getAll() => _repository.getAll();
  Future<AuditModel?> getById(int id) => _repository.getById(id);
  Future<AuditModel> create(AuditModel audit) => _repository.create(audit);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<AuditModel>> getByUser(int userId) =>
      _repository.getByUser(userId);
  Future<List<AuditModel>> getByOperation(String operation) =>
      _repository.getByOperation(operation);
  Future<List<AuditModel>> getByTable(String tableName) =>
      _repository.getByTable(tableName);
  Future<List<AuditModel>> getByAffectedId(int affectedId, String tableName) =>
      _repository.getByAffectedId(affectedId, tableName);
  Future<List<AuditModel>> getByDateRange(
          DateTime startDate, DateTime endDate) =>
      _repository.getByDateRange(startDate, endDate);
}
