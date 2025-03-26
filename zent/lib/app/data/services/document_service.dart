import 'package:get/get.dart';
import '../models/document_model.dart';
import '../providers/document_provider.dart';

class DocumentService extends GetxService {
  final DocumentProvider _provider = DocumentProvider();

  // Valid document types
  final List<String> documentTypes = [
    'Contrato',
    'Factura',
    'Informe',
    'Incidente',
    'Progreso'
  ];

  // Basic CRUD operations
  Future<List<DocumentModel>> getAllDocuments() => _provider.getAll();
  Future<DocumentModel?> getDocumentById(int id) => _provider.getById(id);
  Future<DocumentModel> createDocument(DocumentModel document) =>
      _provider.create(document);
  Future<DocumentModel> updateDocument(DocumentModel document) =>
      _provider.update(document);
  Future<void> deleteDocument(int id) => _provider.delete(id);

  // Specific operations
  Future<List<DocumentModel>> getDocumentsByProject(int projectId) =>
      _provider.getByProject(projectId);
  Future<List<DocumentModel>> getDocumentsByUser(int userId) =>
      _provider.getByUser(userId);
  Future<List<DocumentModel>> getDocumentsByType(String documentType) =>
      _provider.getByType(documentType);
  Future<List<DocumentModel>> searchDocumentsByTitle(String searchTerm) =>
      _provider.searchByTitle(searchTerm);
  Future<List<DocumentModel>> searchDocumentsByContent(String searchTerm) =>
      _provider.searchByContent(searchTerm);

  // Business logic methods
  bool isValidDocumentType(String? type) {
    return type == null || documentTypes.contains(type);
  }

  // Check if document has file attached
  bool hasAttachedFile(DocumentModel document) {
    return document.fileUrl != null && document.fileUrl!.isNotEmpty;
  }

  // Get file extension from URL
  String? getFileExtension(DocumentModel document) {
    if (!hasAttachedFile(document)) return null;

    final fileUrl = document.fileUrl!;
    final segments = fileUrl.split('.');
    if (segments.length > 1) {
      return segments.last.toLowerCase();
    }
    return null;
  }

  // Check if is image type
  bool isImageFile(DocumentModel document) {
    final extension = getFileExtension(document);
    return extension != null &&
        ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  // Check if is PDF
  bool isPdfFile(DocumentModel document) {
    final extension = getFileExtension(document);
    return extension != null && extension == 'pdf';
  }

  // Get icon based on document type
  String getDocumentIcon(DocumentModel document) {
    if (hasAttachedFile(document)) {
      if (isImageFile(document)) return 'assets/icons/image.png';
      if (isPdfFile(document)) return 'assets/icons/pdf.png';
      return 'assets/icons/file.png';
    }

    switch (document.documentType) {
      case 'Contrato':
        return 'assets/icons/contract.png';
      case 'Factura':
        return 'assets/icons/invoice.png';
      case 'Informe':
        return 'assets/icons/report.png';
      case 'Incidente':
        return 'assets/icons/incident.png';
      case 'Progreso':
        return 'assets/icons/progress.png';
      default:
        return 'assets/icons/document.png';
    }
  }
}
