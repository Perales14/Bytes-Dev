import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../controllers/employees_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService());
    }

    // Register controller
    Get.lazyPut<EmployeesController>(() => EmployeesController());
  }
}
