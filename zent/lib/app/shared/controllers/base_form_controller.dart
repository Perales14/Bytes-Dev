import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/models/base_model.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart' as picker;
import '../validators/validators.dart' as validators;

/// Controlador base para formularios que implementa funcionalidad común.
abstract class BaseFormController extends GetxController {
  /// Clave del formulario para validación
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Control de visibilidad de contraseñas
  final RxBool showPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  /// Modelo base que almacena los datos comunes
  late BaseModel modelBase; // Antes: model_base

  /// Lista observable de archivos
  final RxList<FileData> files = <FileData>[].obs;

  /// Notificador de valor para archivos (soporte adicional)
  late final ValueNotifier<List<FileData>> filesNotifier;

  /// Alterna la visibilidad de la contraseña
  void togglePasswordVisibility() => showPassword.value = !showPassword.value;

  /// Alterna la visibilidad de la confirmación de contraseña
  void toggleConfirmPasswordVisibility() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  /// Valida que un campo no esté vacío
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  /// Valida que un email tenga formato correcto
  String? validateEmail(String? value) {
    return validators.validateEmail(value);
  }

  /// Agrega un nuevo archivo PDF desde el selector de archivos del sistema
  Future<void> addNewFile() async {
    try {
      picker.FilePickerResult? result =
          await picker.FilePicker.platform.pickFiles(
        type: picker.FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        // Obtener información del archivo seleccionado
        picker.PlatformFile platformFile = result.files.first;

        // Verificación adicional de seguridad para garantizar que sea PDF
        if (platformFile.extension?.toLowerCase() != 'pdf') {
          Get.snackbar(
            'Error',
            'Solo se permiten archivos PDF',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Crear y agregar el nuevo FileData
        files.add(FileData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: platformFile.name,
          type: FileType.pdf, // Forzamos el tipo a PDF
          uploadDate: DateTime.now(),
          path: platformFile.path,
          size: platformFile.size,
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

  /// Determina el tipo de archivo basado en su extensión
  FileType _getFileTypeFromExtension(String extension) {
    extension = extension.toLowerCase();
    if (extension == 'pdf') return FileType.pdf;
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension)) {
      return FileType.image;
    }
    if (['doc', 'docx'].contains(extension)) return FileType.word;
    if (['xls', 'xlsx'].contains(extension)) return FileType.excel;
    return FileType.other;
  }

  /// Agrega un archivo a la lista
  void addFile(FileData file) {
    files.add(file);
    // También actualizamos el modelo base
    updateBaseModel(files: files);
    files.refresh();
  }

  /// Elimina un archivo de la lista
  void removeFile(FileData file) {
    files.removeWhere((f) => f.id == file.id);
    // También actualizamos el modelo base
    updateBaseModel(files: files);
  }

  /// Actualiza el modelo base con nuevos valores
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
    modelBase = modelBase.copyWith(
      id: id,
      firstName: nombre,
      fatherLastName: apellidoPaterno,
      motherLastName: apellidoMaterno,
      email: correo,
      phone: telefono,
      notes: observaciones,
      registrationDate: fechaRegistro,
      files: files,
    );
  }

  /// Procesa el envío del formulario
  bool submitForm();

  /// Reinicia el formulario a sus valores por defecto
  void resetForm();

  /// Inicializa el modelo base con valores por defecto
  void _initializeBaseModel() {
    modelBase = BaseModel(
      firstName: '',
      fatherLastName: '',
      motherLastName: '',
      email: '',
      phone: '',
      registrationDate: DateTime.now().toString().split(' ')[0],
      notes: '',
    );
    // Sincronizamos los archivos iniciales
    files.clear();
    if (modelBase.files.isNotEmpty) {
      files.addAll(modelBase.files);
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
