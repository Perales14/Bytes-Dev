import 'package:get/get.dart';
import '../../../data/services/address_service.dart';
import '../../../data/services/project_service.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/provider_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/file_service.dart';
import '../controllers/projects_controller.dart';

class ProjectsBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<ProjectService>(() => ProjectService(), fenix: true);
    Get.lazyPut<FileService>(() => FileService(), fenix: true);

    // Servicios adicionales para obtener nombres de clientes y usuarios
    if (!Get.isRegistered<ClientService>()) {
      Get.lazyPut<ClientService>(() => ClientService(), fenix: true);
    }

    if (!Get.isRegistered<ProviderService>()) {
      Get.lazyPut<ProviderService>(() => ProviderService());
    }
    if (!Get.isRegistered<AddressService>()) {
      Get.lazyPut<AddressService>(() => AddressService());
    }

    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService(), fenix: true);
    }

    // Controllers
    Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
  }
}
