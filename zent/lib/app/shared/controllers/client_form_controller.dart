import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/base_form_controller.dart';
import 'package:zent/app/shared/models/client_model.dart';
import 'validators/validators.dart';

/// Controller for the client registration form
class ClientFormController extends BaseFormController {
  // Modelo central que almacena todos los datos del cliente
  late ClientModel model;

  // Client types
  final List<String> tiposCliente = ['Nuevo', 'Regular', 'VIP', 'Corporativo'];

  @override
  void onInit() {
    super.onInit();
    _initializeClient();
  }

  // Inicializa el modelo de cliente con valores por defecto
  void _initializeClient() {
    model = ClientModel(
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
      tipoCliente: '',
    );
  }

  // Validation methods
  String? validateRFC(String? value) {
    return validate_RFC(value);
  }

  String? validateCP(String? value) {
    return validate_CP(value);
  }

  String? validateTipoCliente(String? value) {
    return validateInList(value, tiposCliente, fieldName: 'tipo de cliente');
  }

  @override
  void resetForm() {
    // Primero limpiamos los campos del formulario
    formKey.currentState?.reset();
    // Luego reiniciamos el modelo a sus valores iniciales
    _initializeClient();
  }

  @override
  bool submitForm() {
    // IMPORTANTE: Cambio de tipo de retorno a bool para indicar éxito/fracaso
    // Validamos el formulario completo primero
    if (_validateClientForm()) {
      // Aquí iría la lógica para enviar el formulario
      // Por ahora solo devolvemos true indicando que la validación fue exitosa
      return true;
    }
    return false;
  }

  /// Valida el formulario de cliente antes de enviar
  ///
  /// Este método realiza dos validaciones:
  /// 1. Verifica que todos los campos del formulario pasen sus validaciones individuales
  /// 2. Verifica específicamente que se haya seleccionado un tipo de cliente
  ///
  /// @return true si todas las validaciones pasan, false en caso contrario
  bool _validateClientForm() {
    // Validar todos los campos del formulario (nombre, correo, etc.)
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validación',
        'Por favor complete todos los campos requeridos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validación específica para el tipo de cliente
    if (model.tipoCliente.isEmpty) {
      Get.snackbar(
        'Validación',
        'Por favor seleccione un tipo de cliente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // Actualiza el modelo del cliente con nuevos valores
  void updateClient({
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? fechaRegistro,
    String? observaciones,
    String? nombreEmpresa,
    String? cargo,
    String? calle,
    String? colonia,
    String? cp,
    String? rfc,
    String? tipoCliente,
  }) {
    model = model.copyWith(
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: correo,
      telefono: telefono,
      fechaRegistro: fechaRegistro,
      observaciones: observaciones,
      nombreEmpresa: model.nombreEmpresa,
      cargo: model.cargo,
      calle: model.calle,
      colonia: model.colonia,
      cp: model.cp,
      rfc: model.rfc,
      tipoCliente: model.tipoCliente,
    );
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  ClientModel getClientModel() {
    return model;
  }
}
