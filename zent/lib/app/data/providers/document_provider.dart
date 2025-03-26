import '../models/document_model.dart';
import '../repositories/document_repository.dart';

class DocumentProvider {
  final DocumentRepository _repository = DocumentRepository();

  // Basic CRUD operations
  Future<List<DocumentModel>> getAll() => _repository.getAll();
  Future<DocumentModel?> getById(int id) => _repository.getById(id);
  Future<DocumentModel> create(DocumentModel document) =>
      _repository.create(document);
  Future<DocumentModel> update(DocumentModel document) =>
      _repository.update(document);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<DocumentModel>> getByProject(int projectId) =>
      _repository.getByProject(projectId);
  Future<List<DocumentModel>> getByUser(int userId) =>
      _repository.getByUser(userId);
  Future<List<DocumentModel>> getByType(String documentType) =>
      _repository.getByType(documentType);
  Future<List<DocumentModel>> searchByTitle(String searchTerm) =>
      _repository.searchByTitle(searchTerm);
  Future<List<DocumentModel>> searchByContent(String searchTerm) =>
      _repository.searchByContent(searchTerm);
}
