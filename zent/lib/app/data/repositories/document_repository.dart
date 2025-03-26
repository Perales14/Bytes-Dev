import '../models/base_model.dart';
import '../models/document_model.dart';
import 'base_repository.dart';

class DocumentRepository extends BaseRepository<DocumentModel> {
  DocumentRepository() : super(tableName: 'documents');

  @override
  DocumentModel fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'],
      documentType: map['document_type'],
      title: map['title'] ?? '',
      content: map['content'],
      fileUrl: map['file_url'],
      userId: map['user_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get documents by project
  Future<List<DocumentModel>> getByProject(int projectId) async {
    try {
      return await query('project_id = ?', [projectId]);
    } catch (e) {
      throw Exception('Error getting documents by project: $e');
    }
  }

  // Get documents by user
  Future<List<DocumentModel>> getByUser(int userId) async {
    try {
      return await query('user_id = ?', [userId]);
    } catch (e) {
      throw Exception('Error getting documents by user: $e');
    }
  }

  // Get documents by type
  Future<List<DocumentModel>> getByType(String documentType) async {
    try {
      return await query('document_type = ?', [documentType]);
    } catch (e) {
      throw Exception('Error getting documents by type: $e');
    }
  }

  // Search documents by title
  Future<List<DocumentModel>> searchByTitle(String searchTerm) async {
    try {
      return await query('title LIKE ?', ['%$searchTerm%']);
    } catch (e) {
      throw Exception('Error searching documents by title: $e');
    }
  }

  // Search documents by content
  Future<List<DocumentModel>> searchByContent(String searchTerm) async {
    try {
      return await query('content LIKE ?', ['%$searchTerm%']);
    } catch (e) {
      throw Exception('Error searching documents by content: $e');
    }
  }

  // Create with validation
  @override
  Future<DocumentModel> create(DocumentModel model) async {
    try {
      // Validate document type
      if (model.documentType != null &&
          !isValidDocumentType(model.documentType!)) {
        throw Exception('Invalid document type');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating document: $e');
    }
  }

  // Update with validation
  @override
  Future<DocumentModel> update(DocumentModel model) async {
    try {
      // Validate document type
      if (model.documentType != null &&
          !isValidDocumentType(model.documentType!)) {
        throw Exception('Invalid document type');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error updating document: $e');
    }
  }

  // Check if document type is valid
  bool isValidDocumentType(String type) {
    return ['Contrato', 'Factura', 'Informe', 'Incidente', 'Progreso']
        .contains(type);
  }
}
