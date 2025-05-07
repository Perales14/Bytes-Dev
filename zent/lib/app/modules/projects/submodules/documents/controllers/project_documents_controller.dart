import 'package:get/get.dart';
import 'package:zent/app/data/models/project_model.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/models/base_model.dart';
// importar el filerepository
import 'package:zent/app/data/repositories/file_repository.dart';

/// Controlador para la sección de documentos de un proyecto
class ProjectDocumentsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<FileData> documents = <FileData>[].obs;

  /// Obtiene los archivos asociados a una entidad
  Future<List<FileData>> getFileByEntity(ProjectModel entity) async {
    // return entity.files;
    final Files =
        await FileRepository().getFilesByEntity(entity.id, "employee");

    return Files.map((file) => FileData(
          id: file.id.toString(),
          name: file.name,
          type: FileType.pdf, // Asignar el tipo de archivo correspondiente
          uploadDate: file.uploadDate,
          size: file.size,
        )).toList();
  }

  /// Carga los documentos del proyecto actual
  void loadDocuments(ProjectModel project) {
    isLoading.value = true;

    try {
      // Aquí se cargarían los datos reales desde los servicios correspondientes
      _loadDocuments(project);
    } catch (e) {
      print('Error cargando documentos del proyecto: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga datos de ejemplo para la vista previa
  void _loadDocuments([ProjectModel? project]) {
    Future.delayed(const Duration(milliseconds: 700), () async {
      if (project != null) {
        // Obtener documentos del proyecto usando getFileByEntity
        final projectFiles = await getFileByEntity(project);
        // documents.assignAll(projectFiles);
        documents.assignAll(projectFiles);
      } else {
        // Datos de ejemplo en caso de que no haya un proyecto
        final now = DateTime.now();
        final mockDocs = [
          FileData(
            id: '1',
            name: 'Documento_Proyecto.pdf',
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
        ];
        documents.assignAll(mockDocs);
      }
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
