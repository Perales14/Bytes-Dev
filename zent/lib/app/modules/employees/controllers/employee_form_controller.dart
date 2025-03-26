import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/file_service.dart';
import '../../../data/services/role_service.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/list_validator.dart';
import '../../../shared/validators/nss_validator.dart';
import '../../../shared/validators/password_validator.dart';

class EmployeeFormController extends BaseFormController {
  // Modelo del usuario que estamos editando
  final Rx<UserModel> user = UserModel(
    roleId: 2, // Por defecto es empleado
    name: '',
    fatherLastName: '',
    motherLastName: '',
    email: '',
    socialSecurityNumber: '',
    passwordHash: '',
    entryDate: DateTime.now(),
    stateId: 1, // Activo por defecto
  ).obs;

  // Services para operaciones de base de datos
  final UserService _userService = Get.find<UserService>();
  final FileService _fileService = Get.find<FileService>();
  final RoleService _roleService = Get.find<RoleService>();

  // Controladores de texto persistentes
  final nameController = TextEditingController();
  final fatherLastNameController = TextEditingController();
  final motherLastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final socialSecurityNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final salaryController = TextEditingController();
  final departmentController = TextEditingController();

  // Contraseña de confirmación
  final RxString confirmPassword = ''.obs;

  // Observaciones (manejadas por separado ya que es una tabla polimorfa)
  final observationText = ''.obs;

  // Variables para controlar UI
  @override
  final showPassword = false.obs;

  // Catálogos
  late List<String> roles = ['Administrador'];
  final List<String> contractTypes = ['Temporal', 'Indefinido', 'Por Obra'];

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      // Obtener roles del servicio
      final rolesList = await _roleService.getAllRoles();
      roles = rolesList.map((role) => role.name).toList();
      print('Roles: $roles');
    } catch (e) {
      print('Error al cargar roles: $e');
    }

    resetForm();
  }

  @override
  void onClose() {
    // Liberar recursos de los controladores
    nameController.dispose();
    fatherLastNameController.dispose();
    motherLastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    socialSecurityNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    salaryController.dispose();
    departmentController.dispose();
    super.onClose();
  }

  // Inicializar o resetear formulario
  @override
  void resetForm() {
    user.value = UserModel(
      roleId: 2, // Por defecto es empleado
      name: '',
      fatherLastName: '',
      motherLastName: '',
      email: '',
      socialSecurityNumber: '',
      passwordHash: '',
      entryDate: DateTime.now(),
      stateId: 1, // Activo por defecto
    );

    confirmPassword.value = '';
    observationText.value = '';
    showPassword.value = false;

    // Inicializar los controladores con los valores iniciales
    nameController.text = user.value.name;
    fatherLastNameController.text = user.value.fatherLastName;
    motherLastNameController.text = user.value.motherLastName ?? '';
    emailController.text = user.value.email;
    phoneNumberController.text = user.value.phoneNumber ?? '';
    socialSecurityNumberController.text = user.value.socialSecurityNumber;
    passwordController.text = user.value.passwordHash;
    confirmPasswordController.text = confirmPassword.value;
    salaryController.text = user.value.salary?.toString() ?? '';
    departmentController.text = user.value.department ?? '';

    formKey.currentState?.reset();
  }

  // Actualizar campos del modelo de usuario
  void updateUser({
    String? name,
    String? fatherLastName,
    String? motherLastName,
    String? email,
    String? phoneNumber,
    String? socialSecurityNumber,
    String? passwordHash,
    double? salary,
    String? contractType,
    String? department,
    int? roleId,
    DateTime? entryDate,
  }) {
    user.update((val) {
      if (val != null) {
        if (name != null) val.name = name;
        if (fatherLastName != null) val.fatherLastName = fatherLastName;
        if (motherLastName != null) val.motherLastName = motherLastName;
        if (email != null) val.email = email;
        if (phoneNumber != null) val.phoneNumber = phoneNumber;
        if (socialSecurityNumber != null)
          val.socialSecurityNumber = socialSecurityNumber;
        if (passwordHash != null) val.passwordHash = passwordHash;
        if (salary != null) val.salary = salary;
        if (contractType != null) val.contractType = contractType;
        if (department != null) val.department = department;
        if (roleId != null) val.roleId = roleId;
        if (entryDate != null) val.entryDate = entryDate;
      }
    });

    // Trigger UI update and log values for debugging
    update();
    print('Usuario actualizado: ${user.value.toJson()}');
  }

  // Actualiza la confirmación de contraseña
  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  // Actualizar texto de observación
  void updateObservation(String value) {
    observationText.value = value;
  }

  int getRoleId(String? roleName) {
    if (roleName == null) return 0;
    print('Rol Name: $roleName');
    int roleId = 0;
    roleId = roles.indexOf(roleName) + 1;
    print('Rol ID: $roleId');
    return roleId;
  }

  // Preparar el modelo para guardarlo
  void prepareModelForSave() {
    user.update((val) {
      if (val != null) {
        val.name = nameController.text;
        val.fatherLastName = fatherLastNameController.text;
        val.motherLastName = motherLastNameController.text.isEmpty
            ? null
            : motherLastNameController.text;
        val.email = emailController.text;
        val.phoneNumber = phoneNumberController.text.isEmpty
            ? null
            : phoneNumberController.text;
        val.socialSecurityNumber = socialSecurityNumberController.text;
        val.passwordHash = passwordController.text;
        val.department = departmentController.text.isEmpty
            ? null
            : departmentController.text;
        val.salary = salaryController.text.isEmpty
            ? null
            : double.tryParse(salaryController.text);
      }
    });
  }

  // Muestra/oculta la contraseña
  @override
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  // Carga los datos de un usuario existente
  void loadUser(UserModel model) {
    user.value = model;
    observationText.value = model.department ?? '';

    // Actualizar también los controladores
    nameController.text = model.name;
    fatherLastNameController.text = model.fatherLastName;
    motherLastNameController.text = model.motherLastName ?? '';
    emailController.text = model.email;
    phoneNumberController.text = model.phoneNumber ?? '';
    socialSecurityNumberController.text = model.socialSecurityNumber;
    passwordController.text = model.passwordHash;
    salaryController.text = model.salary?.toString() ?? '';
    departmentController.text = model.department ?? '';

    update();
  }

  // VALIDACIONES

  String? validatePassword(String? value) {
    return validatePassword(value);
  }

  String? validateSocialSecurityNumber(String? value) {
    return validate_NSS(value);
  }

  String? validateContractType(String? value) {
    return validateInList(value, contractTypes, fieldName: 'tipo de contrato');
  }

  String? validateSalary(String? value) {
    return validateSalary(value);
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value != user.value.passwordHash) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // GUARDAR EMPLEADO

  @override
  bool submitForm() {
    if (validateForm()) {
      try {
        prepareModelForSave(); // Preparar el modelo antes de guardar
        saveEmployee();
        return true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al guardar empleado: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return false;
  }

  // Método para guardar referencias de archivos
  Future<void> _saveFileReferences(
      List<Map<String, dynamic>> fileData, int employeeId) async {
    // try {
    //   for (var file in fileData) {
    //     await _fileService.createFile(file);
    //   }
    // } catch (e) {
    //   print('Error al guardar referencias de archivos: $e');
    // }
  }

  Future<bool> saveEmployee() async {
    try {
      // El departamento se puede usar para guardar información temporal
      // que luego se puede mover a la tabla de observaciones
      print('formulario valido: ${validateForm()}');
      if (observationText.value.isNotEmpty) {
        user.update((val) {
          if (val != null) val.department = observationText.value;
        });
      }

      // Guardar o actualizar el usuario usando el servicio
      final savedUser = user.value.id > 0
          ? await _userService.updateUser(user.value)
          : await _userService.createEmployee(user.value);

      if (files.isNotEmpty) {
        // upload
        final uploadedFiles =
            await uploadFilesToSupabase(files, user.value.id.toString());

        // Guarda las referencias de los archivos en la base de datos
        if (uploadedFiles.isNotEmpty) {
          await _saveFileReferences(uploadedFiles, user.value.id);
        }
      }

      if (savedUser.id > 0) {
        Get.snackbar(
          'Éxito',
          'Empleado guardado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        // También podrías guardar la observación en su tabla correspondiente aquí

        return true;
      } else {
        throw Exception('No se pudo guardar el empleado');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validar tipo contrato
    if (user.value.contractType == null || user.value.contractType!.isEmpty) {
      Get.snackbar(
        'Error',
        'Debe seleccionar un tipo de contrato',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validar contraseña y confirmación
    if (user.value.id == 0 && // Solo para nuevos usuarios
        user.value.passwordHash != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'Las contraseñas no coinciden',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
