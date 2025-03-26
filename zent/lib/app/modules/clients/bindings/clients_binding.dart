import 'package:get/get.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/observation_service.dart';
import '../controllers/clients_controller.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar servicios
    if (!Get.isRegistered<ClientService>()) {
      Get.lazyPut<ClientService>(() => ClientService());
    }

    if (!Get.isRegistered<ObservationService>()) {
      Get.lazyPut<ObservationService>(() => ObservationService());
    }

    // Registrar controlador
    Get.lazyPut<ClientsController>(() => ClientsController());
  }
}
