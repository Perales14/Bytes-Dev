import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/usuario_repository.dart';

class EmployeesController extends GetxController {
  final UsuarioRepository _repository = Get.find<UsuarioRepository>();

  // Observable variables
  final RxList<UsuarioModel> employees = <UsuarioModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Get all usuarios (employees)
      final List<UsuarioModel> result = await _repository.getAll();
      employees.assignAll(result);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error al cargar empleados: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Filter employees by role, department, etc.
  void filterByRole(int roleId) async {
    try {
      isLoading.value = true;
      final filteredEmployees = await _repository.getByRole(roleId);
      employees.assignAll(filteredEmployees);
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron filtrar los empleados: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Additional method to get project and task counts for each employee
  // In a real app, these would come from related repositories
  int getProjectCount(int employeeId) {
    // Placeholder - in a real app you would fetch this from a project repository
    return employeeId % 5; // Just for demo
  }

  int getTaskCount(int employeeId) {
    // Placeholder - in a real app you would fetch this from a task repository
    return employeeId % 7 + 1; // Just for demo
  }

  void onEmployeeSelected(UsuarioModel employee) {
    Get.toNamed('/employees/${employee.id}');
  }

  void refreshData() {
    fetchEmployees();
  }
}
