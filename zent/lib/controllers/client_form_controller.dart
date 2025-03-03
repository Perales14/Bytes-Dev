import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';

/// Controller for the client registration form
class ClientFormController extends BaseFormController {
  // Client specific fields
  final nombreEmpresa = ''.obs;
  final cargo = ''.obs;
  final calle = ''.obs;
  final colonia = ''.obs;
  final cp = ''.obs;
  final rfc = ''.obs;
  final tipoCliente = Rx<String?>(null);

  // Client types
  final List<String> tiposCliente = ['Nuevo', 'Regular', 'VIP', 'Corporativo'];

  @override
  void onInit() {
    super.onInit();
    // Initialize date with current date
    fechaRegistro.value = DateTime.now().toString().split(' ')[0];
  }

  // Validation methods
  String? validateRFC(String? value) {
    if (value == null || value.isEmpty) {
      return 'El RFC es requerido';
    }
    if (value.length != 13) {
      return 'El RFC debe tener 13 caracteres';
    }
    return null;
  }

  String? validateCP(String? value) {
    if (value == null || value.isEmpty) {
      return 'El código postal es requerido';
    }
    if (value.length != 5 || !GetUtils.isNumericOnly(value)) {
      return 'Ingrese un código postal válido (5 dígitos)';
    }
    return null;
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    // Common fields
    nombre.value = '';
    apellidoPaterno.value = '';
    apellidoMaterno.value = '';
    correo.value = '';
    telefono.value = '';
    observaciones.value = '';
    id.value = '';

    // Client specific fields
    nombreEmpresa.value = '';
    cargo.value = '';
    calle.value = '';
    colonia.value = '';
    cp.value = '';
    rfc.value = '';
    tipoCliente.value = null;
    fechaRegistro.value = DateTime.now().toString().split(' ')[0];
  }

  @override
  void submitForm() {
    if (_validateClientForm()) {
      Get.snackbar(
        'Éxito',
        'Cliente registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool _validateClientForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (tipoCliente.value == null) {
      Get.snackbar(
        'Error de validación',
        'Debe seleccionar un tipo de cliente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    return true;
  }
}
