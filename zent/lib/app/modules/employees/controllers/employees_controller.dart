import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../widgets/employee_details_dialog.dart';

class EmployeesController extends GetxController {
  // Lista reactiva de empleados
  final employees = <UserModel>[].obs;
  final filter = ''.obs;
  final textController = TextEditingController();

  // Estado de carga
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Servicio
  final UserService _userService;

  // Inyección de dependencia mediante constructor
  EmployeesController({UserService? userService})
      : _userService = userService ?? Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();

    loadEmployees();

    // Configurar listener para el filtro de texto
    textController.addListener(() {
      filter.value = textController.text;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  List<UserModel> filteredEmployees() {
    if (employees.isEmpty) {
      print('No hay empleados');
      return <UserModel>[].obs;
    }

    final filtered = <UserModel>[];

    for (var employee in employees) {
      if (employee.fullName
          .toLowerCase()
          .contains(filter.value.toLowerCase())) {
        filtered.add(employee);
      }
    }

    return filtered;
  }

  // Obtener todos los empleados
  void loadEmployees() async {
    try {
      isLoading(true);
      hasError(false);
      final result = await _userService.getEmployees();
      employees.assignAll(result);
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar empleados: $e');
    } finally {
      isLoading(false);
    }
  }

  // Recargar datos
  void refreshData() {
    loadEmployees();
  }

  bool employeesEmpty() => employees.isEmpty;

  UserModel getUserById(int id) {
    try {
      return employees.firstWhere((user) => user.id == id);
    } catch (e) {
      throw Exception('Usuario con ID $id no encontrado');
    }
  }

  void showEmployeeDetails(int employeeId) {
    try {
      final employee = getUserById(employeeId);

      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return EmployeeDetailsDialog(
            employee: employee,
            onEditPressed: () {
              // Primero cerramos el diálogo
              Navigator.of(context).pop();
              // Luego navegamos a la página de edición
              Get.toNamed('/employees/$employeeId/edit');
            },
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo encontrar la información del empleado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
