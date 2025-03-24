import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/repositories/cliente_repository.dart';

class ClientsController extends GetxController {
  // Lista reactiva de clientes
  final clients = <ClienteModel>[].obs;
  final filtro = ''.obs;
  final TextEditingController textController = TextEditingController();

  // Estado de carga
  var isLoading = true.obs;

  // Estado de error
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Repositorio
  final ClienteRepository _repository;

  // Inyección de dependencia mediante constructor
  ClientsController({ClienteRepository? repository})
      : _repository = repository ?? Get.find<ClienteRepository>();

  @override
  void onInit() {
    super.onInit();
    loadClients();
    textController.addListener(() {
      filtro.value = textController.text;
    });
  }

  List<ClienteModel> empleadosFiltrados() {
    if (clients.isEmpty) {
      print('No hay empleados');
      return <ClienteModel>[].obs;
    }

    final clientes = <ClienteModel>[];
    String nombre = '';
    for (var valor in clients) {
      nombre =
          '${valor.nombre} ${valor.apellidoPaterno} ${valor.apellidoMaterno == null ? '' : valor.apellidoMaterno!}';
      if (nombre.toLowerCase().contains(filtro.value.toLowerCase())) {
        clientes.add(valor);
      }
    }

    return clientes;
  }

  // Future<List<ClienteModel>> filtrarClientes() async {
  //   if (filtro.value.isEmpty) {
  //     return [];
  //   }
  //   return clients.where((cliente) {
  //     return cliente.nombre
  //             .toLowerCase()
  //             .contains(filtro.value.toLowerCase()) ||
  //         cliente.apellidoPaterno
  //             .toLowerCase()
  //             .contains(filtro.value.toLowerCase());
  //   }).toList();
  // }

  // Cargar clientes desde el repositorio
  void loadClients() async {
    try {
      print('Cargando clientes...');
      isLoading(true);
      hasError(false);
      final result = await _repository.getAll();
      print('Clientes cargados: ${result.length}');
      for (var cliente in result) {
        print(cliente.nombre);
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
}
