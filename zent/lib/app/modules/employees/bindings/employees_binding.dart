import 'package:get/get.dart';
import '../../../data/services/file_service.dart';
import '../../../data/services/role_service.dart';
import '../../../data/services/user_service.dart';
import '../controllers/employees_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService(), fenix: true);
    }

    if (!Get.isRegistered<RoleService>()) {
      Get.lazyPut<RoleService>(() => RoleService(), fenix: true);
    }

    if (!Get.isRegistered<FileService>()) {
      Get.lazyPut<FileService>(() => FileService(), fenix: true);
    }

    // Register controller
    Get.lazyPut<EmployeesController>(() => EmployeesController(), fenix: true);
  }
}
