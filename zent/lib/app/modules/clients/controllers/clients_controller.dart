import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_model.dart';
import '../../../data/services/client_service.dart';
import '../widgets/add_clients_dialog.dart';
import '../widgets/client_details_dialog.dart';

/// Controlador para administrar clientes
class ClientsController extends GetxController {
  // Variables observables
  final clients = <ClientModel>[].obs;
  final filter = ''.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Controladores UI
  final TextEditingController textController = TextEditingController();

  // Servicios
  final ClientService _clientService;

  /// Constructor con inyección de dependencias
  ClientsController({ClientService? clientService})
      : _clientService = clientService ?? Get.find<ClientService>();

  @override
  void onInit() {
    super.onInit();
    loadClients();
    textController.addListener(() => filter.value = textController.text);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// Filtra la lista de clientes según el texto de búsqueda
  List<ClientModel> filteredClients() {
    if (clients.isEmpty || filter.value.isEmpty) {
      return clients;
    }

    final searchTerm = filter.value.toLowerCase();
    return clients
        .where((client) =>
            client.fullName.toLowerCase().contains(searchTerm) ||
            (client.companyName?.toLowerCase().contains(searchTerm) ?? false))
        .toList();
  }

  /// Carga clientes activos desde el servicio
  void loadClients() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');

      final result = await _clientService.getActiveClients();
      clients.assignAll(result);

      if (kDebugMode && clients.isEmpty) {
        print('No se encontraron clientes activos');
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar clientes: $e');
      if (kDebugMode) print('Error al cargar clientes: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Recarga la lista de clientes
  void refreshData() => loadClients();

  /// Muestra el diálogo de detalles de un cliente
  void showClientDetails(int clientId) {
    try {
      final client = clients.firstWhere((c) => c.id == clientId);

      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) => ClientDetailsDialog(
          client: client,
          onEditPressed: () {
            // Cerramos primero el diálogo actual
            Navigator.of(context).pop();
            // Programamos la apertura del diálogo de edición para el siguiente frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showEditClientDialog(clientId);
            });
          },
          onClose: refreshData,
        ),
      );
    } catch (e) {
      _showErrorSnackbar('No se pudo encontrar la información del cliente');
    }
  }

  /// Obtiene un cliente por su ID
  ClientModel getClientById(int id) {
    try {
      return clients.firstWhere((client) => client.id == id);
    } catch (e) {
      throw Exception('Cliente con ID $id no encontrado');
    }
  }

  /// Elimina un cliente del sistema
  Future<void> deleteClient(int id) async {
    try {
      await _clientService.deleteClient(id);
      refreshData();
    } catch (e) {
      throw Exception('Error al eliminar el cliente: $e');
    }
  }

  /// Desactiva un cliente (no lo elimina)
  Future<void> setClientInactive(int id) async {
    try {
      await _clientService.setClientInactive(id);
      refreshData();
    } catch (e) {
      throw Exception('Error al desactivar el cliente: $e');
    }
  }

  /// Muestra el diálogo para editar un cliente
  void showEditClientDialog(int clientId) {
    try {
      final client = getClientById(clientId);

      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) => AddClientsDialog(
          client: client,
          onSaveSuccess: refreshData,
          isEditing: true,
        ),
      );
    } catch (e) {
      _showErrorSnackbar(
          'No se pudo encontrar la información del cliente para editar');
    }
  }

  /// Muestra un snackbar de error
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
}
