import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/services/role_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../widgets/add_project_dialog.dart';

class ProjectsController extends GetxController {
  // Estado y propiedades
  final employees = <UserModel>[].obs;
  final filter = ''.obs;
  final textController = TextEditingController();
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final RxList<String> roleNames = <String>[].obs;

  // Dependencias
  final UserService _userService;
  bool _rolesLoaded = false;

  ProjectsController({UserService? userService})
      : _userService = userService ?? Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
    textController.addListener(() {
      filter.value = textController.text;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Operaciones CRUD
  void loadEmployees() async {
    try {
      isLoading(true);
      hasError(false);
      // Cambiar getAllEmployees por getActiveEmployees para solo obtener empleados activos
      final result = await _userService.getActiveEmployees();
      employees.assignAll(result);
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar empleados: $e');
    } finally {
      isLoading(false);
    }
  }

  void refreshData() {
    loadEmployees();
  }

  UserModel getUserById(int id) {
    try {
      return employees.firstWhere((user) => user.id == id);
    } catch (e) {
      throw Exception('Usuario con ID $id no encontrado');
    }
  }

  Future<void> setEmployeeInactive(int id) async {
    try {
      await _userService.setEmployeeInactive(id);
      refreshData();
    } catch (e) {
      throw Exception('Error al desactivar el empleado: $e');
    }
  }

  // Gestión de UI
  List<UserModel> filteredEmployees() {
    if (employees.isEmpty) {
      print('No hay empleados');
      return <UserModel>[];
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

  bool employeesEmpty() => employees.isEmpty;

  void showEditEmployeeDialog(int employeeId) {
    try {
      final employee = getUserById(employeeId);

      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return AddProjectDialog(
            employee: employee,
            onSaveSuccess: () {
              refreshData();
            },
            isEditing: true,
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo encontrar la información del empleado para editar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Gestión de roles
  void loadRolesIfNeeded() async {
    if (!_rolesLoaded) {
      final RoleService roleService = Get.find<RoleService>();
      final rolesList = await roleService.getAllRoles();
      roleNames.value = rolesList.map((role) => role.name).toList();
      _rolesLoaded = true;
    }
  }

  String getRoleName(int roleId) {
    if (roleNames.isEmpty || roleId <= 0 || roleId > roleNames.length) {
      return 'Rol desconocido';
    }
    return roleNames[roleId - 1];
  }
}
