import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/observation_model.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/observation_service.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart';

/// Controller for the client registration form
class ClientFormController extends BaseFormController {
  // Servicios necesarios
  final ClientService _clientService = Get.find<ClientService>();
  final ObservationService _observationService = Get.find<ObservationService>();

  // Modelo central que almacena todos los datos del cliente
  late ClientModel client;

  final observationText = ''.obs;

  // ID del usuario actual (se obtendra del modulo de autenticación)
  final int currentUserId = 1; // Ejemplo: ID del usuario logueado

  // Client types
  final List<String> clientTypes = ['Particular', 'Empresa', 'Gobierno'];

  @override
  void onInit() {
    super.onInit();
    _initializeClient();
  }

  // Inicializa el modelo de cliente con valores por defecto
  void _initializeClient() {
    client = ClientModel(
      name: '',
      fatherLastName: '',
      motherLastName: '',
      email: '',
      phoneNumber: '',
      companyName: '',
      taxIdentificationNumber: '',
      clientType: null,
      stateId: 1, // Valor por defecto
    );

    // Inicializar texto de observación
    observationText.value = '';
  }

  // Validation methods
  String? validateTaxId(String? value) {
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

  String? validateType(String? value) {
    return validateInList(value, clientTypes, fieldName: 'tipo de cliente');
  }

  @override
  void resetForm() {
    // Primero limpiamos los campos del formulario
    formKey.currentState?.reset();
    // Luego reiniciamos el modelo a sus valores iniciales
    _initializeClient();
  }

  // Actualizar texto de observación
  void updateObservation(String value) {
    observationText.value = value;
  }

  @override
  bool submitForm() {
    // Validamos el formulario completo primero
    if (_validateClientForm()) {
      try {
        // Implementamos la llamada real al servicio
        saveClientWithObservation();
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

  // Método para guardar cliente y observación
  Future<bool> saveClientWithObservation() async {
    try {
      // Validar tipo
      if (client.clientType == '') {
        client = client.copyWith(clientType: null);
      }

      // 1. Guardar el cliente primero
      final savedClient = await _clientService.createClient(client);

      if (savedClient.id > 0) {
        // 2. Si hay observación, guardarla
        if (observationText.value.trim().isNotEmpty) {
          await _saveObservation(savedClient.id);
        }

        Get.snackbar(
          'Éxito',
          'Cliente guardado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo guardar el cliente',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }

  // Método para guardar observación
  Future<bool> _saveObservation(int clientId) async {
    try {
      // Crear modelo de observación
      final observation = ObservationModel(
        sourceTable: 'clients', // Nombre de la tabla en la base de datos
        sourceId: clientId,
        observation: observationText.value.trim(),
        userId: currentUserId,
      );

      // Guardar observación en la base de datos
      final savedObservation =
          await _observationService.createObservation(observation);
      return savedObservation.id > 0;
    } catch (e) {
      print('Error al guardar observación: $e');
      return false;
    }
  }

  /// Valida el formulario de cliente antes de enviar
  bool _validateClientForm() {
    // Validar todos los campos del formulario
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validación específica para el tipo de cliente
    if (client.clientType == null || client.clientType!.isEmpty) {
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
    String? name,
    String? fatherLastName,
    String? motherLastName,
    String? email,
    String? phoneNumber,
    String? companyName,
    String? taxIdentificationNumber,
    String? clientType,
    int? stateId,
  }) {
    // Validación para asegurar que tipo sea null o un valor válido
    String? validType = clientType;
    if (validType != null && validType.isEmpty) {
      validType = null;
    }

    try {
      client = ClientModel(
        id: client.id,
        name: name ?? client.name,
        fatherLastName: fatherLastName ?? client.fatherLastName,
        motherLastName: motherLastName ?? client.motherLastName,
        email: email ?? client.email,
        phoneNumber: phoneNumber ?? client.phoneNumber,
        companyName: companyName ?? client.companyName,
        taxIdentificationNumber:
            taxIdentificationNumber ?? client.taxIdentificationNumber,
        clientType: validType, // Usar el valor validado
        stateId: stateId ?? client.stateId,
        addressId: client.addressId,
        createdAt: client.createdAt,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print("Error al actualizar cliente: $e");
    }
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  ClientModel getClientModel() {
    return client;
  }
}
