import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/shared/widgets/form/file_upload_panel.dart';

class EmployeeFormController extends GetxController {
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
  final nss = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  // Company data fields
  final id = ''.obs;
  final fechaRegistro = ''.obs;
  final salario = ''.obs;
  final rol = Rx<String?>(null);
  final tipoContrato = Rx<String?>(null);

  // Observations
  final observaciones = ''.obs;

  // Files
  final files = <FileData>[].obs;

  // Non-reactive files list for direct UI updates
  final ValueNotifier<List<FileData>> filesNotifier =
      ValueNotifier<List<FileData>>([]);

  // Toggle password visibility
  void togglePasswordVisibility() => showPassword.value = !showPassword.value;

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  // Roles and contract types
  final List<String> roles = [
    'Admin',
    'Captador de Campo',
    'Promotor',
    'Recursos Humanos'
  ];

  final List<String> tiposContrato = [
    'Indeterminado',
    'Determinado',
    'Obra/Servicio',
    'Capacitación'
  ];

  // Validation methods
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme su contraseña';
    }
    if (value != password.value) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? validateNSS(String? value) {
    if (value == null || value.isEmpty) {
      return 'El NSS es requerido';
    }
    if (value.length != 11) {
      return 'El NSS debe tener 11 caracteres';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();

    // Sync the filesNotifier with the reactive files list
    ever(files, (filesList) {
      filesNotifier.value = filesList;
    });
  }

  // File handling methods
  void addFile(FileData file) {
    final List<FileData> currentFiles =
        List<FileData>.from(filesNotifier.value);
    currentFiles.add(file);
    filesNotifier.value = currentFiles;

    // If using GetX, also update the reactive list
    files.add(file);
  }

  void removeFile(FileData file) {
    final List<FileData> currentFiles =
        List<FileData>.from(filesNotifier.value);
    currentFiles.removeWhere((f) => f.id == file.id);
    filesNotifier.value = currentFiles;

    // If using GetX, also update the reactive list
    files.removeWhere((f) => f.id == file.id);
  }

  // Mock file upload function that could be called from the UI
  void uploadNewFile() {
    // In a real app, you'd show a file picker here
    // For now, create a dummy file
    addFile(FileData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Document_${DateTime.now().millisecondsSinceEpoch}.pdf',
        type: FileType.pdf,
        uploadDate: DateTime.now()));
  }

  // Form submission
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      // Process the form data
      Get.snackbar(
        'Éxito',
        'Empleado registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resetForm() {
    formKey.currentState?.reset();
    nombre.value = '';
    apellidoPaterno.value = '';
    apellidoMaterno.value = '';
    correo.value = '';
    telefono.value = '';
    nss.value = '';
    password.value = '';
    confirmPassword.value = '';
    id.value = '';
    fechaRegistro.value = '';
    salario.value = '';
    rol.value = null;
    tipoContrato.value = null;
    observaciones.value = '';
    showPassword.value = false;
    showConfirmPassword.value = false;
    files.clear();
  }
}
