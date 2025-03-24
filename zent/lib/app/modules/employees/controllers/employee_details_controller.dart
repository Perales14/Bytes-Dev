import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/usuario_repository.dart';
import 'employee_form_controller.dart';

class EmployeeDetailsController extends GetxController {
  final employeeId = Get.parameters['id'];
  final usuarioRepository = Get.find<UsuarioRepository>();
  final isLoading = true.obs;
  late EmployeeFormController formController;

  @override
  void onInit() {
    super.onInit();
    formController = Get.put(EmployeeFormController());
    loadEmployeeData();
  }

  Future<void> loadEmployeeData() async {
    try {
      isLoading(true);

      if (employeeId == null || employeeId!.isEmpty) {
        Get.snackbar('Error', 'ID de empleado no válido');
        return;
      }

      try {
        final employee =
            await usuarioRepository.getById(int.parse(employeeId!));

        if (employee == null) {
          Get.snackbar('Error', 'No se encontró el empleado');
          return;
        }

        // Cargar los datos en el formulario
        formController.loadUsuario(employee);
      } catch (e) {
        Get.snackbar('Error',
            'Error al obtener datos: ${e.toString().substring(0, 100)}');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateEmployee() async {
    try {
      final success = await formController.saveEmployee();
      if (success) {
        Get.back();
        Get.snackbar('Éxito', 'Información del empleado actualizada');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
    }
  }
}
