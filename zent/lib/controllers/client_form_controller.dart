import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/models/client_model.dart';
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
    formKey.currentState?.reset();
    _initializeClient();
  }

  @override
  void submitForm() {
    if (_validateClientForm()) {
      // Aquí se podría enviar el cliente a un servicio o repositorio
      // clientRepository.save(client);

      Get.snackbar(
        'Éxito',
        'Cliente registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
      return false;
    }

    // Validación específica para el tipo de cliente
    if (model.tipoCliente.isEmpty) {
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

  // Actualiza el modelo del cliente con nuevos valores
  void updateClient({
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
    String? tipoCliente,
    String? fechaRegistro,
  }) {
    model = model.copyWith(
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
      tipoCliente: tipoCliente,
      fechaRegistro: fechaRegistro,
    );
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  ClientModel getClientModel() {
    return model;
  }
}
