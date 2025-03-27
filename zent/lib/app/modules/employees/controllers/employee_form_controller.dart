import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/employees/controllers/employees_controller.dart';
import '../../../data/models/file_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/file_repository.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/file_service.dart';
import '../../../data/services/role_service.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart' as validators;

class EmployeeFormController extends BaseFormController {
  // Añadir referencia al EmployeesController
  final EmployeesController _employeesController =
      Get.find<EmployeesController>();

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
  final List<String> contractTypes = [
    'Temporal',
    'Indefinido',
    'Por Obra/Servicio'
  ];

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
      roleId: 1, // Por defecto es admin
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
        if (socialSecurityNumber != null) {
          val.socialSecurityNumber = socialSecurityNumber;
        }
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

        // Solo actualizar contraseña si estamos creando o si se cambió
        if (val.id == 0 || passwordController.text != val.passwordHash) {
          val.passwordHash = passwordController.text;
        }

        val.salary = salaryController.text.isEmpty
            ? null
            : double.tryParse(salaryController.text);

        val.department = departmentController.text.isEmpty
            ? null
            : departmentController.text;
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
    return validators.validatePassword(value);
  }

  String? validateSocialSecurityNumber(String? value) {
    return validators.validateNSS(value);
  }

  String? validateContractType(String? value) {
    return validators.validateInList(value, contractTypes,
        fieldName: 'tipo de contrato');
  }

  String? validateSalary(String? value) {
    return validators.validateSalary(value);
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
    try {
      // Crea un repositorio para archivos si no lo tienes ya
      final fileRepository = Get.find<FileRepository>();

      for (var file in fileData) {
        // Convert Map to FileModel before passing to createFile
        await fileRepository.saveFile({
          ...file,
          'entity_id': employeeId,
          'entity_type': 'employee',
        });
      }
    } catch (e) {
      print('Error al guardar referencias de archivos: $e');
    }
  }

  Future<bool> saveEmployee() async {
    try {
      if (!validateForm()) {
        return false;
      }

      // Preparar datos del modelo para guardar
      prepareModelForSave();

      // Guardar observación si existe
      if (observationText.value.isNotEmpty) {
        user.update((val) {
          if (val != null) {
            val.department = observationText.value;
          }
        });
      }

      // Guardar o actualizar el usuario usando el servicio
      final savedUser = user.value.id > 0
          ? await _userService.createEmployee(
              user.value) // Reemplazar este metodo por updateEmployee
          : await _userService.createEmployee(user.value);

      // Guardar archivos si hay
      if (files.isNotEmpty) {
        // Implementación para guardar archivos
      }

      if (savedUser.id > 0) {
        Get.snackbar(
          'Éxito',
          user.value.id > 0
              ? 'Empleado actualizado correctamente'
              : 'Empleado creado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.surfaceContainerHighest,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo guardar el empleado',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }

  // Método para obtener el nombre del rol delegando al EmployeesController
  String? getRoleName(int roleId) {
    return _employeesController.getRoleName(roleId);
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
