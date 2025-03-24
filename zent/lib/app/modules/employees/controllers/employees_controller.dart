import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/usuario_repository.dart';

class EmployeesController extends GetxController {
  // Lista reactiva de empleados
  final employees = <UsuarioModel>[].obs;
  final filtro = ''.obs;
  final textController = TextEditingController();

  // Estado de carga
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Repositorio
  final UsuarioRepository _repository;

  // Inyección de dependencia mediante constructor
  EmployeesController({UsuarioRepository? repository})
      : _repository = repository ?? Get.find<UsuarioRepository>();

  @override
  void onInit() {
    super.onInit();

    loadEmployees();

    // Configurar listener para el filtro de texto
    textController.addListener(() {
      filtro.value = textController.text;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  List<UsuarioModel> empleadosFiltrados() {
    if (employees.isEmpty) {
      print('No hay empleados');
      return <UsuarioModel>[].obs;
    }

    final empleados = <UsuarioModel>[];

    for (var valor in employees) {
      if (valor.nombreCompleto
          .toLowerCase()
          .contains(filtro.value.toLowerCase())) {
        empleados.add(valor);
      }
    }

    return empleados;
  }

  // Obtener todos los empleados
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

  // Filtrar empleados por texto
  // void filterEmployees() {
  //   if (filtro.isEmpty) {
  //     loadEmployees();
  //     return;
  //   }

  //   try {
  //     final searchText = filtro.value.toLowerCase();
  //     print('Filtrando empleados por: $searchText');
  //     final filteredEmployees = employees.where((employee) {
  //       return employee.nombreCompleto.toLowerCase().contains(searchText) ||
  //           employee.email.toLowerCase().contains(searchText) ||
  //           (employee.departamento?.toLowerCase().contains(searchText) ??
  //               false);
  //     }).toList();

  //     employees.assignAll(filteredEmployees);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error al filtrar: $e');
  //     }
  //   }
  // }

  // Recargar datos
  void refreshData() {
    loadEmployees();
  }

  bool employeesEmpty() => employees.isEmpty;

  UsuarioModel getUserById(int id) {
    try {
      return employees.firstWhere((user) => user.id == id);
    } catch (e) {
      throw Exception('Usuario con ID $id no encontrado');
    }
  }
}
