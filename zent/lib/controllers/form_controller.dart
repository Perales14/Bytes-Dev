import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  // Form data
  final formKey = GlobalKey<FormState>();

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
  final fechaIngreso = ''.obs;
  final salario = ''.obs;
  final rol = Rx<String?>(null);
  final tipoContrato = Rx<String?>(null);

  // Observations
  final observaciones = ''.obs;

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

  // Form submission
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      // Process the form data
      Get.snackbar(
        'Éxito',
        'Formulario enviado correctamente',
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
    fechaIngreso.value = '';
    salario.value = '';
    rol.value = null;
    tipoContrato.value = null;
    observaciones.value = '';
  }
}
