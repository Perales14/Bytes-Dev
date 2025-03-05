import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/controllers/validators/validators.dart';
import 'package:zent/models/employee_model.dart';
import 'package:zent/shared/widgets/form/widgets/file_upload_panel.dart';

class EmployeeFormController extends BaseFormController {
  // Modelo central que almacena todos los datos del empleado
  late EmployeeModel model;

  // Contraseña de confirmación (mantenida solo en el controlador)
  String confirmPassword = '';

  // Variable para mostrar/ocultar contraseña
  @override
  final showPassword = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    _initializeEmployee();
  }

  // Inicializa el modelo de empleado con valores por defecto
  void _initializeEmployee() {
    model = EmployeeModel(
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      correo: '',
      telefono: '',
      fechaRegistro: DateTime.now().toString().split(' ')[0],
      observaciones: '',
      nss: '',
      password: '',
      salario: '',
      rol: '',
      tipoContrato: '',
    );
    confirmPassword = '';
  }

  // Employee-specific validations
  String? validatePassword(String? value) {
    return validate_Password(value);
  }

  String? validateNSS(String? value) {
    return validate_NSS(value);
  }

  // Validación para el rol de empleado
  String? validateRol(String? value) {
    return validateInList(value, roles, fieldName: 'rol');
  }

  // Validación para el tipo de contrato
  String? validateTipoContrato(String? value) {
    return validateInList(value, tiposContrato, fieldName: 'tipo de contrato');
  }

  String? validateSalario(String? value) {
    return validateSalary(value);
  }

  // Validación para confirmar contraseña
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value != model.password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // Método para actualizar la confirmación de contraseña
  void updateConfirmPassword(String value) {
    confirmPassword = value;
  }

  @override
  void submitForm() {
    if (_validateEmployeeForm()) {
      // Aquí se podría enviar el empleado a un servicio o repositorio
      // employeeRepository.save(employee);

      Get.snackbar(
        'Éxito',
        'Empleado registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Valida el formulario de empleado antes de enviar
  ///
  /// Este método realiza múltiples validaciones:
  /// 1. Verifica que todos los campos del formulario pasen sus validaciones individuales
  /// 2. Verifica específicamente que se haya seleccionado un rol
  /// 3. Verifica específicamente que se haya seleccionado un tipo de contrato
  ///
  /// @return true si todas las validaciones pasan, false en caso contrario
  @override
  bool _validateEmployeeForm() {
    // Validar todos los campos del formulario
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validación específica para el rol
    if (model.rol.isEmpty) {
      Get.snackbar(
        'Error de validación',
        'Debe seleccionar un rol',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    // Validación específica para el tipo de contrato
    if (model.tipoContrato.isEmpty) {
      Get.snackbar(
        'Error de validación',
        'Debe seleccionar un tipo de contrato',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    // Validación específica para la confirmación de contraseña
    if (model.password != confirmPassword) {
      Get.snackbar(
        'Error de validación',
        'Las contraseñas no coinciden',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    return true;
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    _initializeEmployee();
    showPassword.value = false;
    showConfirmPassword.value = false;
    files.clear();
  }

  // Actualiza el modelo del empleado con nuevos valores
  void updateEmployee({
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? observaciones,
    String? nss,
    String? password,
    String? salario,
    String? rol,
    String? tipoContrato,
    String? fechaRegistro,
  }) {
    model = model.copyWith(
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: correo,
      telefono: telefono,
      observaciones: observaciones,
      nss: nss,
      password: password,
      salario: salario,
      rol: rol,
      tipoContrato: tipoContrato,
      fechaRegistro: fechaRegistro,
    );
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  EmployeeModel getEmployeeModel() {
    return model;
  }
}
