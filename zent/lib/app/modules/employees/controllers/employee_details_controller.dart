import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/employee_repository.dart';
import 'employee_form_controller.dart';

class EmployeeDetailsController extends GetxController {
  final employeeId = Get.parameters['id'];
  final employeeRepository = EmployeeRepository();
  final isLoading = true.obs;
  late EmployeeFormController formController;

  @override
  void onInit() {
    super.onInit();
    print('Inicializando EmployeeDetailsController');
    formController = Get.put(EmployeeFormController());
    print('FormController inicializado');
    loadEmployeeData();
  }

  Future<void> loadEmployeeData() async {
    try {
      isLoading.value = true;

      if (employeeId == null || employeeId!.isEmpty) {
        print('ID de empleado no válido o vacío');
        Get.snackbar('Error', 'ID de empleado no válido');
        return;
      }

      print('Cargando datos del empleado con ID: $employeeId');

      try {
        // Obtener los datos del empleado según el ID
        final employee =
            await employeeRepository.getById(int.parse(employeeId!));

        if (employee == null) {
          print('No se encontró el empleado con ID: $employeeId');
          Get.snackbar('Error', 'No se encontró el empleado');
          return;
        }

        print(
            'Datos del empleado recibidos correctamente: ${employee.nombreCompleto}');

        // Cargar los datos en el formulario
        formController.loadEmployeeData(employee);
      } on FormatException catch (e) {
        print('Error de formato en ID: $e');
        Get.snackbar('Error', 'El ID del empleado no es válido');
      } catch (e) {
        print('Error específico al obtener datos: $e');
        String errorMsg = e.toString();
        if (errorMsg.length > 100) {
          errorMsg = '${errorMsg.substring(0, 100)}...';
        }
        Get.snackbar('Error', 'Error al obtener datos: $errorMsg');
      }
    } catch (e) {
      print('Error general: $e');
      Get.snackbar('Error', 'No se pudo cargar los datos del empleado');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmployee() async {
    try {
      final success = formController.saveEmployee();
      if (success) {
        Get.back();
        Get.snackbar('Éxito', 'Información del empleado actualizada');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
    }
  }
}
