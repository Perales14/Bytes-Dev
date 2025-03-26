import 'package:get/get.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../controllers/employees_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsuarioRepository>(() => UsuarioRepository());
    Get.lazyPut<EmployeesController>(() => EmployeesController());
  }
}
