import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'dart:math';
import '../../../data/models/file_model.dart';
import '../../../data/services/file_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/observation_service.dart';
import 'employee_form_controller.dart';
import 'employees_controller.dart';

class EmployeeDetailsController extends GetxController {
  final int employeeId;
  late final FileService _fileService;
  late final ObservationService _observationService;

  final EmployeesController _employeesController =
      Get.find<EmployeesController>();
  final RxList<FileModel> files = <FileModel>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingFiles = true.obs;
  late EmployeeFormController formController;

  EmployeeDetailsController({required this.employeeId});

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    formController = Get.put(EmployeeFormController());
    loadEmployeeData();
    loadFiles();
  }

  void _initializeServices() {
    try {
      _fileService = Get.find<FileService>();
      _observationService = Get.find<ObservationService>();
    } catch (e) {
      if (!Get.isRegistered<FileService>()) {
        Get.put(FileService());
        _fileService = Get.find<FileService>();
      }
      if (!Get.isRegistered<ObservationService>()) {
        Get.put(ObservationService());
        _observationService = Get.find<ObservationService>();
      }
    }
  }

  Future<void> loadEmployeeData() async {
    try {
      isLoading.value = true;
      final employee = _employeesController.getUserById(employeeId);
      formController.loadUser(employee);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al obtener datos del empleado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFiles() async {
    try {
      isLoadingFiles.value = true;
      print('Cargando archivos para empleado: $employeeId');

      final result =
          await _fileService.getFilesByEntity(employeeId, 'employee');

      files.clear();
      files.addAll(result);

      print('Archivos cargados: ${files.length}');
      update();
    } catch (e) {
      print('Error al cargar archivos: $e');
      _showErrorSnackbar('No se pudieron cargar los archivos', e);
    } finally {
      isLoadingFiles.value = false;
      update();
    }
  }

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
        await _downloadFileWithProgress(file.url, filePath);
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

  Future<void> updateEmployee() async {
    try {
      final success = await formController.saveEmployee();
      if (success) {
        Get.back();
        Get.snackbar('Éxito', 'Información del empleado actualizada');
        _employeesController.refreshData();
      }
    } catch (e) {
      _showErrorSnackbar('No se pudo actualizar la información', e);
    }
  }

  Future<void> deleteFile(FileModel file) async {
    try {
      _fileService.prueba(file);
      final confirmed = await _showDeleteConfirmationDialog(file.name);

      if (!confirmed) return;

      _showLoadingDialog('Eliminando archivo...');

      await _fileService.deleteFileCompletely(file);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      await loadFiles();

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
    );
  }
}
