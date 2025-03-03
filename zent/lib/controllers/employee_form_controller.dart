import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
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
