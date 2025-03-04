import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/shared/widgets/form/file_upload_panel.dart';
import 'validators/validators.dart';

abstract class BaseFormController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Password visibility
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  // Personal data fields
  final nombre = ''.obs;
  final apellidoPaterno = ''.obs;
  final apellidoMaterno = ''.obs;
  final correo = ''.obs;
  final telefono = ''.obs;

  // Common company data
  final id = ''.obs;
  final fechaRegistro = ''.obs;

  // Observations
  final observaciones = ''.obs;

  // Files
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
  }

  void removeFile(FileData file) {
    files.removeWhere((f) => f.id == file.id);
  }

  // Abstract methods that must be implemented by subclasses
  void submitForm();
  void resetForm();

  @override
  void onInit() {
    super.onInit();
    filesNotifier = ValueNotifier<List<FileData>>([]);

    // Sync files with notifier
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
