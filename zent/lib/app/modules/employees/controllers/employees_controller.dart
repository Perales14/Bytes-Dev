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
      print('object');
      final result = await _repository.getEmployees();
      print('result');
      print(result.length);

      employees.assignAll(result);
      // final exampleEmployee = UsuarioModel(
      //     id: employees.length + 1, // ID temporal
      //     rolId: 2, // Rol de empleado
      //     nombreCompleto: "María López Sánchez",
      //     email: "maria.lopez@empresa.com",
      //     nss: "12345678912",
      //     contrasenaHash: "password_hash_example",
      //     fechaIngreso:
      //         DateTime.now().subtract(Duration(days: 90)), // Hace 3 meses
      //     salario: 15000.0,
      //     tipoContrato: "Indefinido",
      //     departamento: "Recursos Humanos",
      //     cargo: "Analista",
      //     estadoId: 1, // Activo
      //     telefono: "5512345678");

      // // Agregar a la lista observable
      // employees.add(exampleEmployee);
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
