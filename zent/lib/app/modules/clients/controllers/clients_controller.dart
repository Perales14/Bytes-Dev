import 'package:get/get.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/repositories/cliente_repository.dart';

class ClientsController extends GetxController {
  // Lista reactiva de clientes
  var clients = <ClienteModel>[].obs;

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
  }

  // Cargar clientes desde el repositorio
  void loadClients() async {
    try {
      isLoading(true);
      hasError(false);
      final result = await _repository.getAll();
      clients.assignAll(result);
    } catch (e) {
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
