import 'package:get/get.dart';

import '../../../data/repositories/employee_repository.dart';
import '../controllers/employees_controller.dart';

class EmployeesBinding extends Bindings {
  @override
  void dependencies() {
    // Registramos primero el repositorio
    Get.lazyPut<EmployeeRepository>(() => EmployeeRepository());

    // Luego el controlador que depende del repositorio
    Get.lazyPut<EmployeesController>(() => EmployeesController());
  }
}
