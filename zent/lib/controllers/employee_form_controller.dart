import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/controllers/validators/validators.dart';
import 'package:zent/shared/widgets/form/file_upload_panel.dart';

class EmployeeFormController extends BaseFormController {
  // Employee-specific fields
  final nss = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final salario = ''.obs;
  final rol = Rx<String?>(null);
  final tipoContrato = Rx<String?>(null);

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

  // Employee-specific validations
  String? validatePassword(String? value) {
    return validate_Password(value);
  }

  String? validateConfirmPassword(String? value) {
    return validate_PasswordConfirmation(value, password.value);
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

  @override
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      Get.snackbar(
        'Éxito',
        'Empleado registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
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
