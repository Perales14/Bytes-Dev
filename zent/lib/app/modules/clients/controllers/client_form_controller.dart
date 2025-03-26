import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/models/observacion_model.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/observacion_repository.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart';

/// Controller for the client registration form
class ClientFormController extends BaseFormController {
  // Repositorios necesarios
  final ClienteRepository _clienteRepository = Get.find<ClienteRepository>();
  final ObservacionRepository _observacionRepository =
      Get.find<ObservacionRepository>();

  // Modelo central que almacena todos los datos del cliente
  late ClienteModel clienteModel;

  // Observaciones
  final observacionText = ''.obs;

  // ID del usuario actual (deberías obtenerlo de tu sistema de autenticación)
  final int currentUserId = 1; // Ejemplo: ID del usuario logueado

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
      tipo: null,
      estadoId: 1, // Valor por defecto
    );

    // Inicializar texto de observación
    observacionText.value = '';
  }

  // Validation methods
  String? validateRFC(String? value) {
    print('Validating RFC: $value');
    if (value == null || value.isEmpty) {
      return 'null'; // RFC es opcional
    }

    // Regex para validar RFC
    final rfcRegExp = RegExp(
        r'^([A-ZÑ&]{3,4})(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))([A-Z\d]{2})([A\d])$');
    if (!rfcRegExp.hasMatch(value)) {
      // print('RFC inválido');
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

  // Actualizar texto de observación
  void updateObservacion(String value) {
    observacionText.value = value;
  }

  @override
  bool submitForm() {
    // Validamos el formulario completo primero
    if (_validateClientForm()) {
      try {
        // Implementamos la llamada real al repositorio
        saveClientWithObservacion();
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
  Future<bool> saveClientWithObservacion() async {
    try {
      // Validar tipo
      if (clienteModel.tipo == '') {
        clienteModel.tipo = null;
      }

      // 1. Guardar el cliente primero
      final savedClient = await _clienteRepository.create(clienteModel);

      if (savedClient.id > 0) {
        // 2. Si hay observación, guardarla
        if (observacionText.value.trim().isNotEmpty) {
          await _saveObservacion(savedClient.id);
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
  Future<bool> _saveObservacion(int clienteId) async {
    try {
      // Crear modelo de observación
      final observacion = ObservacionModel(
        tablaOrigen: 'clientes', // Nombre de la tabla en la base de datos
        idOrigen: clienteId,
        observacion: observacionText.value.trim(),
        usuarioId: currentUserId,
      );

      // Guardar observación en la base de datos
      final savedObservacion = await _observacionRepository.create(observacion);
      return savedObservacion.id > 0;
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
    // Validación para asegurar que tipo sea null o un valor válido
    String? validTipo = tipo;
    if (validTipo != null && validTipo.isEmpty) {
      validTipo = null;
    }

    try {
      clienteModel = ClienteModel(
        id: clienteModel.id,
        nombre: nombre ?? clienteModel.nombre,
        apellidoPaterno: apellidoPaterno ?? clienteModel.apellidoPaterno,
        apellidoMaterno: apellidoMaterno ?? clienteModel.apellidoMaterno,
        email: email ?? clienteModel.email,
        telefono: telefono ?? clienteModel.telefono,
        nombreEmpresa: nombreEmpresa ?? clienteModel.nombreEmpresa,
        rfc: rfc ?? clienteModel.rfc,
        tipo: validTipo, // Usar el valor validado
        estadoId: estadoId ?? clienteModel.estadoId,
        idDireccion: clienteModel.idDireccion,
        createdAt: clienteModel.createdAt,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print("Error al actualizar cliente: $e");
    }
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  ClienteModel getClientModel() {
    return clienteModel;
  }
}
