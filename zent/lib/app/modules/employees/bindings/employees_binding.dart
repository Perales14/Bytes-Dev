import 'package:get/get.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../controllers/employees_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure UsuarioRepository is registered
    if (!Get.isRegistered<UsuarioRepository>()) {
      Get.lazyPut(() => UsuarioRepository());
    }

    // Register the controller
    Get.lazyPut<EmployeesController>(
      () => EmployeesController(),
    );
  }
}
