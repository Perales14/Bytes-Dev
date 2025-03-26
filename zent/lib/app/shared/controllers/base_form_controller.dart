import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/models/base_model.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart' as picker;
import '../validators/validators.dart';

abstract class BaseFormController extends GetxController {
  // Cada controlador debe tener su propia clave única
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Password visibility (esto se mantiene observable porque afecta la UI directamente)
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  // Modelo central que almacena todos los datos comunes
  late BaseModel model_base;

  // Files (mantenemos esta lista observable para compatibilidad)
  final files = <FileData>[].obs;

  late final ValueNotifier<List<FileData>> filesNotifier;

  // Toggle password visibility
  void togglePasswordVisibility() => showPassword.value = !showPassword.value;
  void toggleConfirmPasswordVisibility() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  // Validation methods
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  String? validateEmail(String? value) {
    return validate_Email(value);
  }

  Future<void> addNewFile() async {
    try {
      picker.FilePickerResult? result =
          await picker.FilePicker.platform.pickFiles(
        type: picker.FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        // Obtener información del archivo seleccionado
        picker.PlatformFile platformFile = result.files.first;

        // Determinar el tipo de archivo basado en la extensión
        FileType fileType =
            _getFileTypeFromExtension(platformFile.extension ?? '');

        // Crear y agregar el nuevo FileData
        files.add(FileData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: platformFile.name,
          type: fileType,
          uploadDate: DateTime.now(),
          path: platformFile.path, // Guarda la ruta del archivo
          size: platformFile.size, // Tamaño en bytes
        ));

        // Actualizar el modelo base
        updateBaseModel(files: files);
        files.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Método auxiliar para determinar el tipo de archivo
  FileType _getFileTypeFromExtension(String extension) {
    extension = extension.toLowerCase();
    if (extension == 'pdf') return FileType.pdf;
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension))
      return FileType.image;
    if (['doc', 'docx'].contains(extension)) return FileType.word;
    if (['xls', 'xlsx'].contains(extension)) return FileType.excel;
    return FileType.other;
  }

  // File handling methods
  void addFile(FileData file) {
    files.add(file);
    // También actualizamos el modelo base
    updateBaseModel(files: files);
    files.refresh();
  }

  void removeFile(FileData file) {
    files.removeWhere((f) => f.id == file.id);
    // También actualizamos el modelo base
    updateBaseModel(files: files);
  }

  // Actualiza el modelo base con nuevos valores
  void updateBaseModel({
    String? id,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? observaciones,
    String? fechaRegistro,
    List<FileData>? files,
  }) {
    model_base = model_base.copyWith(
      id: id,
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: correo,
      telefono: telefono,
      observaciones: observaciones,
      fechaRegistro: fechaRegistro,
      files: files,
    );
  }

  // Abstract methods that must be implemented by subclasses
  bool
      submitForm(); // Cambiar tipo de retorno a bool para indicar éxito/fracaso
  void resetForm();

  // Initialize base model
  void _initializeBaseModel() {
    model_base = BaseModel(
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      correo: '',
      telefono: '',
      fechaRegistro: DateTime.now().toString().split(' ')[0],
      observaciones: '',
    );
    // Sincronizamos los archivos iniciales
    files.clear();
    if (model_base.files.isNotEmpty) {
      files.addAll(model_base.files);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeBaseModel();
    filesNotifier = ValueNotifier<List<FileData>>([]);

    // Mantener la sincronización existente para compatibilidad
    ever(files, (filesList) {
      filesNotifier.value = List<FileData>.from(filesList);
    });
  }

  @override
  void onClose() {
    filesNotifier.dispose();
    super.onClose();
  }
}
