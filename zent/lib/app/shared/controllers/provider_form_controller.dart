import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/base_form_controller.dart';
import 'package:zent/app/shared/controllers/validators/validators.dart';
import 'package:zent/app/shared/models/provider_model.dart';

class ProviderFormController extends BaseFormController {
  // Modelo central que almacena todos los datos del proveedor
  late ProviderModel provider;

  // Lists for dropdowns
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
  bool submitForm() {
    // IMPORTANTE: Cambio de tipo de retorno a bool para indicar éxito/fracaso
    if (_validateProviderForm()) {
      // Aquí iría la lógica para enviar el formulario
      // Por ahora solo devolvemos true indicando que la validación fue exitosa
      return true;
    }
    return false;
  }

  /// Valida el formulario de proveedor antes de enviar
  bool _validateProviderForm() {
    // Validar todos los campos del formulario
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validación',
        'Por favor complete todos los campos requeridos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validación específica para el tipo de servicio
    if (provider.tipoServicio.isEmpty) {
      Get.snackbar(
        'Validación',
        'Por favor seleccione un tipo de servicio',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  @override
  void resetForm() {
    // Primero limpiamos los campos del formulario
    formKey.currentState?.reset();
    // Luego reiniciamos el modelo a sus valores iniciales
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
