import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_documents_controller.dart';
import '../../../../../../app/data/models/project_model.dart';
import '../../../../../../app/data/services/project_context_service.dart';
import '../../../../../../app/shared/widgets/form/widgets/file_upload_panel.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';

/// Vista para la sección de documentos de un proyecto
class ProjectDocumentsView extends GetView<ProjectDocumentsController> {
  const ProjectDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final projectContextService = Get.find<ProjectContextService>();

    // Verificamos que exista un proyecto en el contexto
    if (projectContextService.currentProject == null) {
      return _buildErrorState('No se ha seleccionado un proyecto');
    }

    final ProjectModel project = projectContextService.currentProject!;

    // Cargamos los datos cuando se construye la vista
    controller.loadDocuments(project);

    return MainLayout(
      pageTitle: 'Documentos: ${project.name}',
      textController: TextEditingController(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Listado de documentos
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final documents = controller.documents;

                    if (documents.isEmpty) {
                      return _buildEmptyState();
                    }

                    return _buildDocumentsList(documents);
                  }),

                  // Botón flotante dentro del Stack
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _showUploadDialog,
                      tooltip: 'Subir documento',
                      child: const Icon(Icons.upload_file),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el estado de error
  Widget _buildErrorState([String? message]) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar documentos',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message ?? 'No se pudieron cargar los documentos del proyecto',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.offNamed('/projects'),
            child: const Text('Volver a Proyectos'),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de documentos
  Widget _buildDocumentsList(List<FileData> documents) {
    return ListView.separated(
      itemCount: documents.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _buildDocumentItem(doc);
      },
    );
  }

  /// Construye un elemento de documento
  Widget _buildDocumentItem(FileData doc) {
    return ListTile(
      leading: _getFileIcon(doc.type),
      title: Text(doc.name),
      subtitle: Text(_formatDate(doc.uploadDate)),
      onTap: () => _showDocumentOptions(doc),
    );
  }

  /// Obtiene el icono según el tipo de archivo
  Widget _getFileIcon(FileType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case FileType.pdf:
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case FileType.image:
        iconData = Icons.image;
        iconColor = Colors.blue;
        break;
      case FileType.other:
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, size: 24, color: iconColor),
    );
  }

  /// Formatea la fecha de subida
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Formatea el tamaño del archivo
  String _formatFileSize(int sizeInKB) {
    if (sizeInKB < 1024) {
      return '$sizeInKB KB';
    } else {
      final sizeInMB = (sizeInKB / 1024).toStringAsFixed(2);
      return '$sizeInMB MB';
    }
  }

  /// Construye el estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay documentos en este proyecto',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega documentos usando el botón de abajo',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de opciones de documento
  void _showDocumentOptions(FileData doc) {
    Get.dialog(
      AlertDialog(
        title: Text(doc.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Ver documento'),
              onTap: () {
                Get.back();
                // Aquí se implementaría la visualización del documento
                Get.snackbar(
                  'Información',
                  'Visualizando documento: ${doc.name}',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Descargar'),
              onTap: () {
                Get.back();
                // Aquí se implementaría la descarga del documento
                Get.snackbar(
                  'Información',
                  'Descargando documento: ${doc.name}',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar'),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(doc);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de confirmación de eliminación
  void _showDeleteConfirmation(FileData doc) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro que deseas eliminar el documento "${doc.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Get.back();
              controller.removeDocument(doc);
              Get.snackbar(
                'Información',
                'Documento eliminado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo para subir un nuevo documento
  void _showUploadDialog() {
    // Aquí se implementaría el diálogo para subir un nuevo documento
    Get.dialog(
      AlertDialog(
        title: const Text('Subir nuevo documento'),
        content: const Text('Funcionalidad por implementar'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.addNewDocument();
              Get.snackbar(
                'Información',
                'Documento subido correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Subir'),
          ),
        ],
      ),
    );
  }
}
