import '../models/file_model.dart';
import '../repositories/file_repository.dart';

class FileProvider {
  final FileRepository _repository = FileRepository();

  // Basic CRUD operations
  Future<List<FileModel>> getAll() => _repository.getAll();
  Future<FileModel?> getById(int id) => _repository.getById(id);
  Future<FileModel> create(FileModel file) => _repository.create(file);
  Future<FileModel> update(FileModel file) => _repository.update(file);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<FileModel>> getFilesByEntity(int entityId, String entityType) =>
      _repository.getFilesByEntity(entityId, entityType);
  Future<List<FileModel>> getFilesByType(String type) =>
      _repository.getFilesByType(type);
  Future<List<FileModel>> searchByName(String searchTerm) =>
      _repository.searchByName(searchTerm);
  Future<FileModel> saveFile(Map<String, dynamic> fileData) =>
      _repository.saveFile(fileData);
  Future<List<FileModel>> getUnsent() => _repository.getUnsent();
  Future<void> markAsSent(int id) => _repository.markAsSent(id);
}
