import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/employee_repository.dart';

class EmployeesController extends GetxController {
  // Lista reactiva de empleados
  final employees = <UsuarioModel>[].obs;
  final filtro = ''.obs;
  final TextEditingController Textcontrolador = TextEditingController();  
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
    // filtro.value = Textcontrolador.text;
    this.empleados().then((value) => employees.value = value);

    Textcontrolador.addListener(() {
      print('VALOR  ${Textcontrolador.text}');
      // print('filtro$filtro');
      filtro.value = Textcontrolador.text;
      // refresh();
    });
    // employees.listen(onData)
    

  }


  bool employeesEmpty() {
    return employees.isEmpty;
  }

  void refresh(){
    var entradas = <UsuarioModel>[];
    final empleados = <UsuarioModel>[].obs;  // Cambiado de Map a List
      
      
    for (var valor in employees){
      if(valor.nombreCompleto.toLowerCase().contains(filtro.value.toLowerCase())){
          print('Contiene "${filtro.value}"');
          print('Valor: '+valor.nombreCompleto);
          entradas.add(valor);
        }
    }

      empleados.assignAll(entradas);  // Ahora es correcto porque ambos son listas
      // print('lista');
      // print(empleados.toList());
      // print('lista de empleados con "al":');
      for (var empleado in empleados) {
        print(empleado.nombreCompleto);
      }
      // print(empleados.value.keys);
      employees.assignAll(empleados);
      // employees.refresh();
  }

  List<UsuarioModel> empleadosFiltrados() {

    if(employees.isEmpty){
      print('No hay empleados');
      return <UsuarioModel>[].obs;
    }

    List<UsuarioModel> empleados = <UsuarioModel>[].obs;
  
    // empleados = employees.where((element) => element.nombreCompleto.toLowerCase().contains(filtro.value.toLowerCase())).toList();
    // this.empleados().then((value) => empleados = value);

    var entradas = <UsuarioModel>[];
    final filtrados = <UsuarioModel>[].obs;  // Cambiado de Map a List
      
      
    for (var valor in employees){
      if(valor.nombreCompleto.toLowerCase().contains(filtro.value.toLowerCase())){
          print('Contiene "${filtro.value}"');
          print('Valor: '+valor.nombreCompleto);
          entradas.add(valor);
        }
    }

      filtrados.assignAll(entradas);  // Ahora es correcto porque ambos son listas
      // print('lista');
      // print(empleados.toList());
      // print('lista de empleados con "al":');
      for (var empleado in filtrados) {
        print(empleado.nombreCompleto);
      }
      // print(empleados.value.keys);
      // employees.assignAll(empleados);
      empleados.assignAll(filtrados);

    return empleados;

  }
  // employees = <UsuarioModel>[].obs;
  Future<List<UsuarioModel>>  empleados() async {
    List<UsuarioModel> empleados = <UsuarioModel>[].obs;
    try {
      isLoading(true);
      hasError(false);
      // print('object');
      final result = await _repository.getEmployees();
      print('result');

      // employees.assignAll(result);
      empleados = result;
      
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar empleados: $e');
    } finally {
      isLoading(false);
    }
    // return employees;
    return empleados;
  }

  // Cargar empleados desde el repositorio
  void loadEmployees() async {
    // filtro.val(Get.find())
    try {
      isLoading(true);
      hasError(false);
      // print('object');
      final result = await _repository.getEmployees();
      print('result');

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
