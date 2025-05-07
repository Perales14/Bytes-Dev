import 'package:get/get.dart';
import 'package:zent/app/data/models/project_model.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';

/// Controlador para la sección de documentos de un proyecto
class ProjectDocumentsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<FileData> documents = <FileData>[].obs;

  /// Carga los documentos del proyecto actual
  void loadDocuments(ProjectModel project) {
    isLoading.value = true;

    try {
      // Aquí se cargarían los datos reales desde los servicios correspondientes
      // Por ahora usamos datos de ejemplo
      _loadMockDocuments();
    } catch (e) {
      print('Error cargando documentos del proyecto: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga datos de ejemplo para la vista previa
  void _loadMockDocuments() {
    Future.delayed(const Duration(milliseconds: 700), () {
      final now = DateTime.now();

      final mockDocs = [
        FileData(
          id: '1',
          name: 'Plan_Proyecto.pdf',
          type: FileType.pdf,
          uploadDate: now.subtract(const Duration(days: 30)),
          size: 2048,
        ),
        FileData(
          id: '2',
          name: 'Requerimientos_Cliente.pdf',
          type: FileType.pdf,
          uploadDate: now.subtract(const Duration(days: 25)),
          size: 1536,
        ),
        FileData(
          id: '3',
          name: 'Diseño_UI.png',
          type: FileType.image,
          uploadDate: now.subtract(const Duration(days: 20)),
          size: 5120,
        ),
        FileData(
          id: '4',
          name: 'Diagrama_Arquitectura.png',
          type: FileType.image,
          uploadDate: now.subtract(const Duration(days: 18)),
          size: 4096,
        ),
        FileData(
          id: '5',
          name: 'Contrato_Firmado.pdf',
          type: FileType.pdf,
          uploadDate: now.subtract(const Duration(days: 15)),
          size: 3072,
        ),
      ];

      documents.assignAll(mockDocs);
      isLoading.value = false;
    });
  }

  /// Agrega un nuevo documento (simulado para la interfaz)
  void addNewDocument() {
    final now = DateTime.now();
    final newDocument = FileData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Nuevo_Documento_${documents.length + 1}.pdf',
      type: FileType.pdf,
      uploadDate: now,
      size: 1024,
    );

    documents.add(newDocument);
  }

  /// Elimina un documento
  void removeDocument(FileData doc) {
    documents.removeWhere((d) => d.id == doc.id);
  }

  /// Actualiza la lista de documentos
  void refreshDocuments(ProjectModel project) {
    loadDocuments(project);
  }
}
