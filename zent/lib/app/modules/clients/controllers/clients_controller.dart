import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/client_model.dart';
import '../../../data/services/client_service.dart';
import '../widgets/client_details_dialog.dart';

class ClientsController extends GetxController {
  // Lista reactiva de clientes
  final clients = <ClientModel>[].obs;
  final filter = ''.obs;
  final TextEditingController textController = TextEditingController();

  // Estado de carga
  final isLoading = true.obs;

  // Estado de error
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Servicio
  final ClientService _clientService;

  // Inyección de dependencia mediante constructor
  ClientsController({ClientService? clientService})
      : _clientService = clientService ?? Get.find<ClientService>();

  @override
  void onInit() {
    super.onInit();
    loadClients();
    textController.addListener(() {
      filter.value = textController.text;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  List<ClientModel> filteredClients() {
    if (clients.isEmpty) {
      print('No hay clientes');
      return <ClientModel>[].obs;
    }

    final filteredList = <ClientModel>[];
    String name = '';
    for (var client in clients) {
      name = client.fullName;
      if (name.toLowerCase().contains(filter.value.toLowerCase())) {
        filteredList.add(client);
      }
    }

    return filteredList;
  }

  // Cargar clientes desde el servicio
  void loadClients() async {
    try {
      print('Cargando clientes...');
      isLoading(true);
      hasError(false);
      final result = await _clientService.getAllClients();
      print('Clientes cargados: ${result.length}');
      for (var client in result) {
        print(client.name);
      }
      clients.assignAll(result);
    } catch (e) {
      print('Error al cargar clientes: $e');
      hasError(true);
      errorMessage('Error al cargar clientes: $e');
    } finally {
      isLoading(false);
    }
  }

  // Recargar datos
  void refreshData() {
    loadClients();
  }

  // Mostrar detalles del cliente
  void showClientDetails(int clientId) {
    try {
      final client = clients.firstWhere((c) => c.id == clientId);

      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return ClientDetailsDialog(
            client: client,
            onEditPressed: () {
              // Primero cerramos el diálogo
              Navigator.of(context).pop();
              // Luego navegamos a la página de edición
              Get.toNamed('/clients/$clientId/edit');
            },
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo encontrar la información del cliente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  ClientModel getClientById(int id) {
    try {
      return clients.firstWhere((client) => client.id == id);
    } catch (e) {
      throw Exception('Cliente con ID $id no encontrado');
    }
  }
}
