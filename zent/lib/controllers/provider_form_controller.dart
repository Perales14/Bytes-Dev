import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/controllers/validators/validators.dart';
import 'package:zent/shared/models/provider_model.dart';

class ProviderFormController extends BaseFormController {
  // Modelo central que almacena todos los datos del proveedor
  late ProviderModel provider;

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
    _initializeProvider();
  }

  // Inicializa el modelo de proveedor con valores por defecto
  void _initializeProvider() {
    provider = ProviderModel(
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      correo: '',
      telefono: '',
      fechaRegistro: DateTime.now().toString().split(' ')[0],
      observaciones: '',
      nombreEmpresa: '',
      cargo: '',
      calle: '',
      colonia: '',
      cp: '',
      rfc: '',
      tipoServicio: tiposServicio.first,
    );
  }

  // Validación específica para el proveedor
  String? validateRFC(String? value) {
    return validate_RFC(value);
  }

  String? validateCP(String? value) {
    return validate_CP(value);
  }

  String? validateTipoServicio(String? value) {
    return validateInList(value, tiposServicio, fieldName: 'tipo de servicio');
  }

  @override
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      // Aquí podrías enviar el proveedor a un servicio o repositorio
      // providerRepository.save(provider);

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
    _initializeProvider();
  }

  // Actualiza el modelo del proveedor con nuevos valores
  void updateProvider({
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? observaciones,
    String? nombreEmpresa,
    String? cargo,
    String? calle,
    String? colonia,
    String? cp,
    String? rfc,
    String? tipoServicio,
    String? fechaRegistro,
  }) {
    provider = provider.copyWith(
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: correo,
      telefono: telefono,
      observaciones: observaciones,
      nombreEmpresa: nombreEmpresa,
      cargo: cargo,
      calle: calle,
      colonia: colonia,
      cp: cp,
      rfc: rfc,
      tipoServicio: tipoServicio,
      fechaRegistro: fechaRegistro,
    );
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  ProviderModel getProviderModel() {
    return provider;
  }
}
