import 'package:get/get.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/observacion_repository.dart';
import '../controllers/clients_controller.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    // Registramos los repositorios
    Get.lazyPut<ClienteRepository>(() => ClienteRepository());
    Get.lazyPut<ObservacionRepository>(() => ObservacionRepository());

    // Luego el controlador que depende del repositorio
    Get.lazyPut<ClientsController>(() => ClientsController());
  }
}
