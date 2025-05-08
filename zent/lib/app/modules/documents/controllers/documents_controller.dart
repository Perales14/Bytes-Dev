import 'package:get/get.dart';
import 'package:zent/app/data/models/file_model.dart';
import 'package:zent/app/data/repositories/file_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zent/app/data/services/file_service.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class DocumentsController extends GetxController {
  final FileRepository _fileRepository = Get.find<FileRepository>();
  late final FileService _fileService;

  // Observable list to store the files
  final RxList<FileModel> files = <FileModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
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

  // Method to get all files from repository
  Future<List<FileModel>> getAllFiles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Use the getAll method from BaseRepository through FileRepository
      final List<FileModel> allFiles = await _fileRepository.getAll();

      // Update the observable list
      files.assignAll(allFiles);

      return allFiles;
    } catch (e) {
      errorMessage.value = 'Error al cargar los archivos: $e';
      return [];
    } finally {
      isLoading.value = false;
    }
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

      // Actualizar la lista de archivos
      await getAllFiles();

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
