import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/cliente_model.dart';
import '../../data/repositories/cliente_repository.dart';
import 'base_form_controller.dart';
import 'validators/validators.dart';

/// Controller for the client registration form
class ClientFormController extends BaseFormController {
  // Cliente repository
  final ClienteRepository _repository = Get.find<ClienteRepository>();

  // Modelo central que almacena todos los datos del cliente
  late ClienteModel clienteModel;

  // Client types
  final List<String> tiposCliente = ['Particular', 'Empresa', 'Gobierno'];

  @override
  void onInit() {
    super.onInit();
    _initializeClient();
  }

  // Inicializa el modelo de cliente con valores por defecto
  void _initializeClient() {
    clienteModel = ClienteModel(
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      email: '',
      telefono: '',
      nombreEmpresa: '',
      rfc: '',
      tipo: '',
      estadoId: 1, // Valor por defecto
    );
  }

  // Validation methods
  String? validateRFC(String? value) {
    if (value == null || value.isEmpty) {
      return null; // RFC es opcional
    }

    // Regex para validar RFC
    final rfcRegExp = RegExp(
        r'^([A-ZÑ&]{3,4})(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))([A-Z\d]{2})([A\d])$');
    if (!rfcRegExp.hasMatch(value)) {
      return 'RFC inválido';
    }
    return null;
  }

  String? validateTipo(String? value) {
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
    // Validamos el formulario completo primero
    if (_validateClientForm()) {
      try {
        // Aquí iría la lógica para guardar el cliente
        // _repository.save(clienteModel);
        return true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al guardar el cliente: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }
    }
    return false;
  }

  /// Valida el formulario de cliente antes de enviar
  bool _validateClientForm() {
    // Validar todos los campos del formulario
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validación específica para el tipo de cliente
    if (clienteModel.tipo == null || clienteModel.tipo!.isEmpty) {
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
    String? email,
    String? telefono,
    String? nombreEmpresa,
    String? rfc,
    String? tipo,
    int? estadoId,
  }) {
    clienteModel = ClienteModel(
      id: clienteModel.id,
      nombre: nombre ?? clienteModel.nombre,
      apellidoPaterno: apellidoPaterno ?? clienteModel.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? clienteModel.apellidoMaterno,
      email: email ?? clienteModel.email,
      telefono: telefono ?? clienteModel.telefono,
      nombreEmpresa: nombreEmpresa ?? clienteModel.nombreEmpresa,
      rfc: rfc ?? clienteModel.rfc,
      tipo: tipo ?? clienteModel.tipo,
      estadoId: estadoId ?? clienteModel.estadoId,
      idDireccion: clienteModel.idDireccion,
      createdAt: clienteModel.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  ClienteModel getClientModel() {
    return clienteModel;
  }
}
