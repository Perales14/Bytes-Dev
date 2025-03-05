import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/models/base_model.dart';
import 'package:zent/shared/widgets/form/widgets/file_upload_panel.dart';
import 'validators/validators.dart';

abstract class BaseFormController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

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

  // File handling methods
  void addFile(FileData file) {
    files.add(file);
    // También actualizamos el modelo base
    updateBaseModel(files: files);
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
  void submitForm();
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
