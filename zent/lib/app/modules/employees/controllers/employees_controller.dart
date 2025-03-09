import 'package:get/get.dart';
import '../../../data/repositories/usuario_repository.dart';

class EmployeesController extends GetxController {
  // Lista reactiva de empleados (usando mapas)
  var employees = <Map<String, dynamic>>[].obs;

  // Estado de carga
  var isLoading = true.obs;

  // Estado de error
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Repositorio
  final UsuarioRepository usuarioRepository;

  EmployeesController() : usuarioRepository = Get.find<UsuarioRepository>();

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  // Cargar empleados desde el repositorio
  void loadEmployees() async {
  try {
    isLoading(true);
    // Simulación de datos
    final empleadosSimulados = [
      {
        'nombre_completo': 'luis muñoz',
        'nss': '12345',
        'email': 'luis@example.com',
        'cargo': 'Desarrollador',
        'departamento': 'backend',
        'telefono': '8333011843',
      },
      {
        'nombre_completo': 'julian cruz',
        'nss': '67890',
        'email': 'julian@example.com',
        'cargo': 'desarollador',
        'departamento': 'frontend',
        'telefono': '8333011843',
      },
      {
        'nombre_completo': 'Alex Arath',
        'nss': '67890',
        'email': 'falex@example.com',
        'cargo': 'lider',
        'departamento': 'full stack',
        'telefono': '8333011843',
      },
      {
        'nombre_completo': 'Marco Saenz',
        'nss': '67890',
        'email': 'bodrio@example.com',
        'cargo': 'lider',
        'departamento': 'gestor',
        'telefono': '8333011843',
      },
    ];
    employees.assignAll(empleadosSimulados);
    isLoading(false);
  } catch (e) {
    isLoading(false);
    hasError(true);
    errorMessage('Error al cargar empleados: $e');
  }
}

  // Recargar datos
  void refreshData() {
    hasError(false);
    loadEmployees();
  }
}
