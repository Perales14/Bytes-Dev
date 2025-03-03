import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';

class ProviderFormController extends BaseFormController {
  // Company data
  final nombreEmpresa = ''.obs;
  final cargo = ''.obs;

  // Address data
  final calle = ''.obs;
  final colonia = ''.obs;
  final cp = ''.obs;

  // Contact info
  final rfc = ''.obs;

  // Provider specific data
  final tipoServicio = Rx<String?>(null);

  // Lists for dropdowns
  final List<String> roles = ['Admin', 'Usuario', 'Proveedor'];
  final List<String> tiposServicio = [
    'Consultoría',
    'Insumos',
    'Mantenimiento',
    'Software'
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default values
    fechaRegistro.value = DateTime.now().toString().split(' ')[0];
    tipoServicio.value = tiposServicio.first;
  }

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
    if (!GetUtils.isNumericOnly(value) || value.length != 5) {
      return 'Ingrese un código postal válido (5 dígitos)';
    }
    return null;
  }

  @override
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      Get.snackbar(
        'Éxito',
        'Proveedor registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    // Company data
    nombreEmpresa.value = '';
    cargo.value = '';

    // Address data
    calle.value = '';
    colonia.value = '';
    cp.value = '';

    // Personal data
    nombre.value = '';
    apellidoPaterno.value = '';
    apellidoMaterno.value = '';

    // Contact info
    correo.value = '';
    telefono.value = '';
    rfc.value = '';

    // Other fields
    id.value = '';
    observaciones.value = '';
    tipoServicio.value = tiposServicio.first;

    // Reset fecha registro to current date
    fechaRegistro.value = DateTime.now().toString().split(' ')[0];
  }

  Map<String, dynamic> getFormData() {
    return {
      'id': id.value,
      'fechaRegistro': fechaRegistro.value,
      'tipoServicio': tipoServicio.value,
      'nombreEmpresa': nombreEmpresa.value,
      'cargo': cargo.value,
      'calle': calle.value,
      'colonia': colonia.value,
      'cp': cp.value,
      'nombre': nombre.value,
      'apellidoPaterno': apellidoPaterno.value,
      'apellidoMaterno': apellidoMaterno.value,
      'correo': correo.value,
      'telefono': telefono.value,
      'rfc': rfc.value,
      'observaciones': observaciones.value,
    };
  }
}
