import 'package:file_picker/file_picker.dart' as picker;
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zent/app/data/models/project_model.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/models/base_model.dart';
import 'package:zent/app/data/repositories/file_repository.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'dart:math';
import 'package:zent/app/data/models/file_model.dart';
import 'package:zent/app/data/services/file_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/data/providers/supabase/supabase_client.dart';

/// Controlador para la sección de documentos de un proyecto
class ProjectDocumentsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<FileModel> documents = <FileModel>[].obs;
  late final FileService _fileService;
  final RxList<File> files = <File>[].obs;
  final textController = TextEditingController();
  final filter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    textController.addListener(() {
      filter.value = textController.text;
    });
  }

  void _initializeServices() {
    try {
      _fileService = Get.find<FileService>();
    } catch (e) {
      if (!Get.isRegistered<FileService>()) {
        Get.put(FileService());
        _fileService = Get.find<FileService>();
      }
    }
  }

  /// Obtiene los archivos asociados a una entidad
  Future<List<FileModel>> getFileByEntity(ProjectModel entity) async {
    final Files = await FileRepository().getFilesByEntity(entity.id, "project");

    return Files;
    // Files.map((file) => FileData(
    //       id: file.id.toString(),
    //       name: file.name,
    //       type: FileType.pdf,
    //       uploadDate: file.uploadDate,
    //       size: file.size,
    //     )).toList();
  }

  /// Carga datos de ejemplo para la vista previa
  void _loadDocuments([ProjectModel? project]) {
    Future.delayed(const Duration(milliseconds: 700), () async {
      if (project != null) {
        final projectFiles = await getFileByEntity(project);
        documents.assignAll(projectFiles);
      }

      isLoading.value = false;
    });
  }

  /// Retorna los documentos filtrados según el texto de búsqueda
  List<FileModel> get filteredDocuments {
    if (documents.isEmpty) {
      return <FileModel>[];
    }

    if (filter.value.isEmpty) {
      return documents;
    }

    final filtered = <FileModel>[];
    for (var document in documents) {
      if (document.name.toLowerCase().contains(filter.value.toLowerCase())) {
        filtered.add(document);
      }
    }
    return filtered;
  }

  Future<void> handleDroppedFiles(
      List<File> droppedFiles, ProjectModel project) async {
    print('Archivos arrastrados: $droppedFiles');

    // Filtrar solo archivos .pdf (ignorando mayúsculas)
    final pdfFiles = droppedFiles.where((file) {
      final ext = path.extension(file.path).toLowerCase();
      return ext == '.pdf';
    }).toList();

    if (pdfFiles.isEmpty) {
      Get.snackbar(
        'Advertencia',
        'Solo se permiten archivos PDF',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      files.assignAll(pdfFiles);

      _showLoadingDialog('Subiendo archivos...');

      final uploadedFiles = await uploadFilesToSupabase(
        pdfFiles,
        project.id.toString(),
      );

      if (uploadedFiles.isNotEmpty) {
        await saveFileReferences(uploadedFiles, project.id, 'project');
        refreshDocuments(project);

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.snackbar(
          'Éxito',
          'Archivos PDF subidos correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _showErrorSnackbar('Error al subir archivos', e);
    }
  }

  // Future<void> handleDroppedFiles(
  //     List<File> droppedFiles, ProjectModel project) async {
  //   print('Archivos arrastrados: $droppedFiles');
  //   try {
  //     files.assignAll(
  //         droppedFiles); // ← Usamos droppedFiles (el parámetro) y files (el RxList del controller)

  //     _showLoadingDialog('Subiendo archivos...');

  //     final uploadedFiles = await uploadFilesToSupabase(
  //       droppedFiles,
  //       project.id.toString(),
  //     );

  //     if (uploadedFiles.isNotEmpty) {
  //       await saveFileReferences(uploadedFiles, project.id, 'project');
  //       refreshDocuments(project);

  //       if (Get.isDialogOpen ?? false) {
  //         Get.back();
  //       }

  //       Get.snackbar(
  //         'Éxito',
  //         'Archivos subidos correctamente',
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //     } else {
  //       if (Get.isDialogOpen ?? false) {
  //         Get.back();
  //       }
  //     }
  //   } catch (e) {
  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //     _showErrorSnackbar('Error al subir archivos', e);
  //   }
  // }

  /// Carga los documentos del proyecto actual
  void loadDocuments(ProjectModel project) {
    isLoading.value = true;

    try {
      _loadDocuments(project);
    } catch (e) {
      print('Error cargando documentos del proyecto: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Selecciona archivos para subir al proyecto
  Future<void> selectFiles(ProjectModel project) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: picker.FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        _showLoadingDialog('Subiendo archivos...');
        List<File> selectedFiles = [];

        for (var platformFile in result.files) {
          if (platformFile.path != null) {
            selectedFiles.add(File(platformFile.path!));
          }
        }

        // Subir archivos a Supabase y guardar referencias en la base de datos
        if (selectedFiles.isNotEmpty) {
          files.assignAll(selectedFiles);
          final uploadedFiles =
              await uploadFilesToSupabase(files, project.id.toString());
          if (uploadedFiles.isNotEmpty) {
            await saveFileReferences(uploadedFiles, project.id, 'project');
            refreshDocuments(project);

            if (Get.isDialogOpen ?? false) {
              Get.back();
            }

            Get.snackbar(
              'Éxito',
              'Archivos subidos correctamente',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _showErrorSnackbar('Error al seleccionar archivos', e);
    }
  }

  /// Sube archivos a Supabase
  Future<List<Map<String, dynamic>>> uploadFilesToSupabase(
      List<File> fileList, String entityId) async {
    try {
      final supabaseClient = await SupabaseClientManager.instance;
      final client = supabaseClient.client;
      List<Map<String, dynamic>> uploadedFiles = [];

      for (File file in fileList) {
        final fileName = path.basename(file.path);
        final fileBytes = await file.readAsBytes();
        final fileExtension =
            path.extension(file.path).toLowerCase().replaceFirst('.', '');
        final fileSize = file.lengthSync();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final uniqueFileName = '${entityId}_${timestamp}_$fileName';

        // Subir el archivo al bucket de Supabase
        final response = await client.storage.from('documents').uploadBinary(
              uniqueFileName,
              fileBytes,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
              // fileOptions: FileOptions(
              //   contentType: _getContentType(fileExtension),
              // ),
            );

        // Obtener la URL pública del archivo
        final fileUrl =
            client.storage.from('documents').getPublicUrl(uniqueFileName);

        uploadedFiles.add({
          'name': fileName,
          'type': fileExtension,
          'url': fileUrl,
          'size': fileSize,
          'storage_path': response,
        });
      }

      return uploadedFiles;
    } catch (e) {
      _showErrorSnackbar('Error al subir archivos', e);

      return [];
    }
  }

  /// Guarda las referencias de los archivos en la base de datos
  Future<void> saveFileReferences(List<Map<String, dynamic>> uploadedFiles,
      int entityId, String entityType) async {
    try {
      for (var fileData in uploadedFiles) {
        final fileModel = FileModel(
          id: 0, // ID será asignado por la base de datos
          name: fileData['name'],
          type: fileData['type'],
          url: fileData['url'],
          storagePath: fileData['storage_path'],
          uploadDate: DateTime.now(),
          entityId: entityId,
          entityType: entityType,
          size: fileData['size'],
          sent: false, // Por defecto, el archivo no ha sido enviado
        );

        await _fileService.createFile(fileModel);
      }
    } catch (e) {
      _showErrorSnackbar('Error al guardar referencias de archivos', e);
    }
  }

  // Future<void> saveFileReferences(List<Map<String, dynamic>> fileData,
  //     int entityId, String entityType) async {
  //   try {
  //     // Crea un repositorio para archivos si no lo tienes ya
  //     final fileRepository = Get.find<FileRepository>();

  //     for (var file in fileData) {
  //       // Convert Map to FileModel before passing to createFile
  //       await fileRepository.saveFile({
  //         ...file,
  //         'entity_id': entityId,
  //         'entity_type': entityType,
  //       });
  //     }
  //   } catch (e) {
  //     print('Error al guardar referencias de archivos: $e');
  //   }
  // }

  /// Elimina un documento
  void removeDocument(FileData doc) {
    documents.removeWhere((d) => d.id == doc.id);
  }

  /// Actualiza la lista de documentos
  void refreshDocuments(ProjectModel project) {
    loadDocuments(project);
  }

  Future<List<String>> getFileUrlbyid(String id) {
    return FileRepository().getFileUrlById(id);
  }

  /// Descarga un archivo
  Future<void> downloadFile(FileModel file) async {
    try {
      if (kIsWeb) {
        final Uri url = Uri.parse(file.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'No se pudo abrir el archivo';
        }
      } else {
        _showDownloadingSnackbar(file.name);
        final filePath = await _getDownloadPath(file.name);
        print('Ruta de descarga: $filePath');
        await _downloadFileWithProgress(file.url, filePath);
        print('Archivo descargado en: $filePath');
        _showDownloadCompleteSnackbar(filePath);
      }
    } catch (e) {
      print('Error en la descarga: $e');
      _showErrorSnackbar('No se pudo descargar el archivo', e);
    }
  }

  Future<String> _getDownloadPath(String fileName) async {
    late Directory directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getApplicationDocumentsDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    return '${directory.path}/$fileName';
  }

  Future<void> _downloadFileWithProgress(String url, String filePath) async {
    final dio = Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(0);
          print('Progreso de descarga: $progress%');
        }
      },
    );
  }

  void _showDownloadingSnackbar(String fileName) {
    Get.snackbar(
      'Descargando',
      'Descargando $fileName...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showDownloadCompleteSnackbar(String filePath) {
    final directory = filePath.substring(0, filePath.lastIndexOf('/'));

    Get.snackbar(
      'Descarga completa',
      'Archivo guardado en $directory',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () async {
          await OpenFile.open(filePath);
        },
        child: Text(
          'ABRIR',
          style: TextStyle(
            color: Get.theme.colorScheme.secondary,
            fontWeight: Get.textTheme.displayMedium!.fontWeight,
          ),
        ),
      ),
    );
  }

  /// Elimina un archivo
  Future<void> deleteFile(FileModel file) async {
    try {
      final confirmed = await _showDeleteConfirmationDialog(file.name);

      if (!confirmed) return;

      _showLoadingDialog('Eliminando archivo...');

      await _fileService.deleteFileCompletely(file);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Éxito',
        'Archivo eliminado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _showErrorSnackbar('No se pudo eliminar el archivo', e);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String fileName) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Eliminar archivo'),
            content: Text(
                '¿Está seguro que desea eliminar el archivo "$fileName"? Esta acción no se puede deshacer.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Get.theme.colorScheme.secondary),
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.error,
                  foregroundColor: Get.theme.colorScheme.onError,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showLoadingDialog(String message) {
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorSnackbar(String message, dynamic error) {
    Get.snackbar(
      'Error',
      '$message: ${error.toString().substring(0, min(100, error.toString().length))}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
    );
  }
}
