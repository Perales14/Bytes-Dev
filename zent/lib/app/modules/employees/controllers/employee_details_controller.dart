import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'dart:math'; // Para la función min()
import '../../../data/models/file_model.dart';
import '../../../data/services/file_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import 'employee_form_controller.dart';
import 'employees_controller.dart';

class EmployeeDetailsController extends GetxController {
  final int employeeId;
  final FileService _fileService = Get.find<FileService>();

  final controller = Get.find<EmployeesController>();
  RxList<FileModel> files = <FileModel>[].obs;

  RxBool isLoading = true.obs;
  late EmployeeFormController formController;

  EmployeeDetailsController({required this.employeeId});

  @override
  void onInit() {
    super.onInit();
    formController = Get.put(EmployeeFormController());
    loadEmployeeData();
    loadFiles();
  }

  Future<void> loadEmployeeData() async {
    try {
      isLoading.value = true;

      try {
        final employee = controller.getUserById(employeeId);

        // Cargar los datos en el formulario
        formController.loadUser(employee);
      } catch (e) {
        Get.snackbar('Error',
            'Error al obtener datos: ${e.toString().substring(0, 100)}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFiles() async {
    try {
      isLoading.value = true;
      files.value = await _fileService.getFilesByEntity(employeeId, 'employee');
      update();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar los archivos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadFile(FileModel file) async {
    try {
      if (kIsWeb) {
        // En web, abrimos la URL directamente
        if (await canLaunchUrl(Uri.parse(file.url))) {
          await launchUrl(Uri.parse(file.url));
        } else {
          throw 'No se pudo abrir el archivo';
        }
      } else {
        // Mostrar snackbar de inicio de descarga
        Get.snackbar(
          'Descargando',
          'Descargando ${file.name}...',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Determinar directorio de descarga según plataforma
        late Directory directory;
        if (Platform.isAndroid) {
          // Para Android necesitamos obtener el directorio de descargas
          directory = Directory('/storage/emulated/0/Download');
          // Verificar si existe, si no, usar directorio de documentos
          if (!await directory.exists()) {
            directory = await getApplicationDocumentsDirectory();
          }
        } else {
          // Para iOS y otros, usar directorio de documentos
          directory = await getApplicationDocumentsDirectory();
        }

        final filePath = '${directory.path}/${file.name}';

        // Implementar la descarga real con dio
        final dio = Dio();
        await dio.download(
          file.url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              // Podrías actualizar un progreso aquí si quisieras mostrar una barra de progreso
              final progress = (received / total * 100).toStringAsFixed(0);
              print('Progreso de descarga: $progress%');
            }
          },
        );

        // Una vez descargado, mostrar snackbar y permitir abrir el archivo
        Get.snackbar(
          'Descarga completa',
          'Archivo guardado en ${directory.path}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () async {
              // Abrir el archivo con la aplicación predeterminada
              await OpenFile.open(filePath);
            },
            child: const Text('ABRIR'),
          ),
        );
      }
    } catch (e) {
      print('Error en la descarga: $e');
      Get.snackbar(
        'Error',
        'No se pudo descargar el archivo: ${e.toString().substring(0, min(100, e.toString().length))}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateEmployee() async {
    try {
      final success = await formController.saveEmployee();
      if (success) {
        Get.back();
        Get.snackbar('Éxito', 'Información del empleado actualizada');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
    }
  }
}
