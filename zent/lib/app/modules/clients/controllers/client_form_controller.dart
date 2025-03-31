import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/observation_model.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/observation_service.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart';
import 'clients_controller.dart';

/// Controller para formulario de clientes
class ClientFormController extends BaseFormController {
  // Servicios
  final ClientService _clientService = Get.find<ClientService>();
  final ObservationService _observationService = Get.find<ObservationService>();

  // Datos del formulario
  late ClientModel client;
  final observationText = ''.obs;
  final int currentUserId = 1; // ID temporal del usuario actual

  // Catálogos
  final List<String> clientTypes = ['Particular', 'Empresa', 'Gobierno'];

  @override
  void onInit() {
    super.onInit();
    _initializeClient();
  }

  /// Inicializa modelo con valores por defecto
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
      stateId: 1,
    );
    observationText.value = '';
  }

  /// Carga datos de cliente existente
  void loadClient(ClientModel model) {
    try {
      // Usamos una copia para evitar referencias compartidas
      client = model.copyWith();
      observationText.value = '';
      // Utilizamos update() directamente sin operaciones Rx intermedias
      update();
    } catch (e) {
      if (kDebugMode) print("Error al cargar cliente: $e");
    }
  }

  /// Valida RFC mexicano
  String? validateTaxId(String? value) {
    if (value == null || value.isEmpty) return null;

    final rfcRegExp = RegExp(
        r'^([A-ZÑ&]{3,4})(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))([A-Z\d]{2})([A\d])$');
    if (!rfcRegExp.hasMatch(value)) return 'RFC inválido';
    return null;
  }

  /// Valida tipo de cliente
  String? validateType(String? value) {
    return validateInList(value, clientTypes, fieldName: 'tipo de cliente');
  }

  /// Reinicia formulario a valores iniciales
  @override
  void resetForm() {
    formKey.currentState?.reset();
    _initializeClient();
  }

  /// Actualiza texto de observación
  void updateObservation(String value) {
    observationText.value = value;
  }

  /// Valida y envía formulario
  @override
  bool submitForm() {
    if (_validateClientForm()) {
      try {
        if (client.id > 0) {
          updateExistingClient();
        } else {
          saveClientWithObservation();
        }
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

  /// Guarda cliente nuevo con observación
  Future<bool> saveClientWithObservation() async {
    try {
      if (client.clientType == '') {
        client = client.copyWith(clientType: null);
      }

      final savedClient = await _clientService.createClient(client);

      if (savedClient.id > 0) {
        if (observationText.value.trim().isNotEmpty) {
          await _saveObservation(savedClient.id);
        }

        _refreshClientsList();

        Get.snackbar(
          'Éxito',
          'Cliente guardado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }

      Get.snackbar(
        'Error',
        'No se pudo guardar el cliente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
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

  /// Actualiza cliente existente
  Future<bool> updateExistingClient() async {
    try {
      if (client.clientType == '') {
        client = client.copyWith(clientType: null);
      }

      await _clientService.updateClient(client);
      _refreshClientsList();

      Get.snackbar(
        'Éxito',
        'Cliente actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al actualizar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }

  /// Guarda observación en base de datos
  Future<bool> _saveObservation(int clientId) async {
    try {
      final observation = ObservationModel(
        sourceTable: 'clients',
        sourceId: clientId,
        observation: observationText.value.trim(),
        userId: currentUserId,
      );

      final savedObservation =
          await _observationService.createObservation(observation);
      return savedObservation.id > 0;
    } catch (e) {
      if (kDebugMode) print('Error al guardar observación: $e');
      return false;
    }
  }

  /// Actualiza lista de clientes en controller principal
  void _refreshClientsList() {
    try {
      Get.find<ClientsController>().refreshData();
    } catch (_) {
      // Manejo silencioso si el controlador no está disponible
    }
  }

  /// Valida formulario completo antes de enviar
  bool _validateClientForm() {
    if (!formKey.currentState!.validate()) return false;

    if (client.clientType == '') {
      client = client.copyWith(clientType: null);
    }

    if (client.clientType == null) {
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

  /// Actualiza propiedades del modelo cliente
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
    try {
      String? validType = clientType;
      if (validType != null && validType.isEmpty) {
        validType = null;
      }

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
        clientType: validType ?? client.clientType,
        stateId: stateId ?? client.stateId,
        addressId: client.addressId,
        createdAt: client.createdAt,
        updatedAt: DateTime.now(),
      );
      update();
    } catch (e) {
      if (kDebugMode) print("Error al actualizar cliente: $e");
    }
  }

  /// Retorna modelo actual
  ClientModel getClientModel() {
    return client;
  }
}
