import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/models/usuario_model.dart';

import '../../data/repositories/employee_repository.dart';
import '../models/employee_model.dart';
import 'base_form_controller.dart';
import 'validators/list_validator.dart';
import 'validators/nss_validator.dart';
import 'validators/password_validator.dart';
import 'validators/salary_validator.dart';

class EmployeeFormController extends BaseFormController {
  // Modelo central que almacena todos los datos del empleado
  late EmployeeModel model;
  final employeeRepository = EmployeeRepository();

  // Contraseña de confirmación (mantenida solo en el controlador)
  String confirmPassword = '';

  // Variable para mostrar/ocultar contraseña
  @override
  final showPassword = false.obs;

  // Roles and contract types
  final List<String> roles = [
    'Admin',
    'Captador de Campo',
    'Promotor',
    'Recursos Humanos'
  ];

  final List<String> tiposContrato = [
    // 'Indeterminado',
    // 'Determinado',
    // 'Obra/Servicio',
    // 'Capacitación'
    'Temporal', 'Indefinido', 'Por Obra'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeEmployee();
  }

  // Inicializa el modelo de empleado con valores por defecto
  void _initializeEmployee() {
    model = EmployeeModel(
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      correo: '',
      telefono: '',
      fechaRegistro: DateTime.now().toString().split(' ')[0],
      observaciones: '',
      nss: '',
      password: '',
      salario: '',
      rol: '2',
      tipoContrato: '',
    );
    confirmPassword = '';
  }

  // Employee-specific validations
  String? validatePassword(String? value) {
    return validate_Password(value);
  }

  String? validateNSS(String? value) {
    return validate_NSS(value);
  }

  // Validación para el rol de empleado
  String? validateRol(String? value) {
    return validateInList(value, roles, fieldName: 'rol');
  }

  // Validación para el tipo de contrato
  String? validateTipoContrato(String? value) {
    return validateInList(value, tiposContrato, fieldName: 'tipo de contrato');
  }

  String? validateSalario(String? value) {
    return validateSalary(value);
  }

  // Validación para confirmar contraseña
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value != model.password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // Método para actualizar la confirmación de contraseña
  void updateConfirmPassword(String value) {
    confirmPassword = value;
  }

  void loadEmployeeData(UsuarioModel usuario) {
    try {
      print('Cargando datos del usuario en el formulario: ${usuario.toJson()}');

      // Dividir el nombre completo en partes
      List<String> nombrePartes = [];
      if (usuario.nombreCompleto.isNotEmpty) {
        nombrePartes = usuario.nombreCompleto.split(' ');
      }

      String nombre = nombrePartes.isNotEmpty ? nombrePartes[0] : '';
      String apellidoPaterno = nombrePartes.length > 1 ? nombrePartes[1] : '';
      String apellidoMaterno = nombrePartes.length > 2 ? nombrePartes[2] : '';

      print(
          'Nombre dividido - Nombre: $nombre, AP: $apellidoPaterno, AM: $apellidoMaterno');

      // Actualizar el modelo con los datos del usuario
      model = EmployeeModel(
        nombre: nombre,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        correo: usuario.email,
        telefono: usuario.telefono ?? '',
        fechaRegistro: usuario.fechaIngreso.toString().split(' ')[0],
        observaciones: usuario.departamento ?? '',
        nss: usuario.nss,
        password: '',
        salario: usuario.salario?.toString() ?? '',
        rol: usuario.rolId.toString(),
        tipoContrato: usuario.tipoContrato ?? '',
      );

      print('Modelo actualizado exitosamente: ${model.nombre}');
      update(); // Notificar a GetX que los datos cambiaron
    } catch (e) {
      print('Error al cargar datos en el formulario: $e');
      throw Exception('Error al cargar datos en el formulario: $e');
    }
  }

  @override
  bool submitForm() {
    if (_validateEmployeeForm()) {
      // UsuarioModel usuario = UsuarioModel(
      //   rolId: model.rol as int,
      //   nombreCompleto: model_base.nombre,
      //   email: model_base.correo,
      //   nss: model.nss,
      //   contrasenaHash: model.password,
      //   fechaIngreso: model.fechaRegistro as DateTime,
      //   estadoId: 1,
      // );
      // employeeRepository.create(usuario);

      Get.snackbar(
        'Éxito',
        'Empleado VALIDADO registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      Get.snackbar(
        'Éxito',
        'Empleado NO VALIDADO',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return false;
  }

  bool saveEmployee() {
    bool save = false;
    print(model.rol);
    int rol = 0;

    switch (model.rol) {
      case 'Admin':
        rol = 2;
        break;
      case 'Captador de Campo':
        rol = 1;
        break;
      case 'Promotor':
        rol = 3;
        break;
      case 'Recursos Humanos':
        rol = 4;
        break;
      default:
        rol = 2;
    }
    // print('model: ${model.fechaRegistro}');
    // print('model: ');
    // print(model.toJson());
    // print('model_base: ');
    // print(model_base.toJson());

    UsuarioModel usuario = UsuarioModel(
      //valores que son nulos actualmente.
      //cargo,depatamento,especialidadId,salario,supervisorId,telefono,tipoContrato
      rolId: rol,
      nombreCompleto:
          '${model_base.nombre} ${model_base.apellidoPaterno} ${model_base.apellidoMaterno}',
      email: model_base.correo,
      telefono: model_base.telefono,
      nss: model.nss,
      contrasenaHash: model.password,
      // salario: model.salario as double,
      salario: double.parse(model.salario),

      tipoContrato: model.tipoContrato,
      // cargo: model.rol,

      // salario: model.salario as double,
      // fechaIngreso: model.fechaRegistro as DateTime,
      fechaIngreso: DateTime.parse(model.fechaRegistro),

      estadoId: 1,
    );

    print(usuario.toJson());

    employeeRepository.create(usuario).then(
      (value) {
        print('value: ${value.id}');
        if (value.id > 0) {
          save = true;
        }
      },
    );
    return save;
  }

  /// Valida el formulario de empleado antes de enviar
  ///
  /// Este método realiza múltiples validaciones:
  /// 1. Verifica que todos los campos del formulario pasen sus validaciones individuales
  /// 2. Verifica específicamente que se haya seleccionado un rol
  /// 3. Verifica específicamente que se haya seleccionado un tipo de contrato
  ///
  /// @return true si todas las validaciones pasan, false en caso contrario
  bool _validateEmployeeForm() {
    // Validar todos los campos del formulario
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validación específica para el rol
    if (model.rol.isEmpty) {
      Get.snackbar(
        'Error de validación',
        'Debe seleccionar un rol',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    // Validación específica para el tipo de contrato
    if (model.tipoContrato.isEmpty) {
      Get.snackbar(
        'Error de validación',
        'Debe seleccionar un tipo de contrato',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    // Validación específica para la confirmación de contraseña
    if (model.password != confirmPassword) {
      Get.snackbar(
        'Error de validación',
        'Las contraseñas no coinciden',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    return true;
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    _initializeEmployee();
    showPassword.value = false;
    showConfirmPassword.value = false;
    files.clear();
  }

  // Actualiza el modelo del empleado con nuevos valores
  void updateEmployee({
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? observaciones,
    String? nss,
    String? password,
    String? salario,
    String? rol,
    String? tipoContrato,
    String? fechaRegistro,
  }) {
    model = model.copyWith(
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: correo,
      telefono: telefono,
      observaciones: observaciones,
      nss: nss,
      password: password,
      salario: salario,
      rol: rol,
      tipoContrato: tipoContrato,
      fechaRegistro: fechaRegistro,
    );
  }

  // Obtener el modelo actual para guardarlo o enviarlo
  EmployeeModel getEmployeeModel() {
    return model;
  }
}
