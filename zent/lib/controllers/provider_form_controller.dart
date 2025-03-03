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

  // Personal data
  final nombre = ''.obs;
  final apellidoPaterno = ''.obs;
  final apellidoMaterno = ''.obs;

  // Contact info
  final correo = ''.obs;
  final telefono = ''.obs;
  final rfc = ''.obs;

  // Company assigned data
  final id = ''.obs;
  final fechaRegistro = ''.obs;
  final rol = ''.obs;
  final tipoServicio = ''.obs;

  // Observations
  final observaciones = ''.obs;

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
    rol.value = roles.first;
    tipoServicio.value = tiposServicio.first;
  }

  // Validation methods
  String? validateRequired(String? value) {
    return (value == null || value.isEmpty) ? 'Este campo es requerido' : null;
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
  Map<String, dynamic> getFormData() {
    return {
      'id': id.value,
      'fechaRegistro': fechaRegistro.value,
      'rol': rol.value,
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

  @override
  void resetForm() {
    nombreEmpresa.value = '';
    cargo.value = '';
    calle.value = '';
    colonia.value = '';
    cp.value = '';
    nombre.value = '';
    apellidoPaterno.value = '';
    apellidoMaterno.value = '';
    correo.value = '';
    telefono.value = '';
    rfc.value = '';
    observaciones.value = '';
    rol.value = roles.first;
    tipoServicio.value = tiposServicio.first;
  }
}
