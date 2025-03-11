import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/employee_repository.dart';

class EmployeesController extends GetxController {
  // Lista reactiva de empleados
  var employees = <UsuarioModel>[].obs;

  // Estado de carga
  var isLoading = true.obs;

  // Estado de error
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Repositorio
  final EmployeeRepository _repository;

  // Inyección de dependencia mediante constructor
  EmployeesController({EmployeeRepository? repository})
      : _repository = repository ?? Get.find<EmployeeRepository>();

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  // Cargar empleados desde el repositorio
  void loadEmployees() async {
    try {
      isLoading(true);
      hasError(false);
      final result = await _repository.getEmployees();
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
}
