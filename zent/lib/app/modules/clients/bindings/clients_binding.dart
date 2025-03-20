import 'package:get/get.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../controllers/clients_controller.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    // Registramos primero el repositorio
    Get.lazyPut<ClienteRepository>(() => ClienteRepository());

    // Luego el controlador que depende del repositorio
    Get.lazyPut<ClientsController>(() => ClientsController());
  }
}
