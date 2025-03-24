import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/models/rol_model.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../../../data/repositories/rol_repository.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/list_validator.dart';
import '../../../shared/validators/nss_validator.dart';
import '../../../shared/validators/password_validator.dart';
import '../../../shared/validators/salary_validator.dart';

class EmployeeFormController extends BaseFormController {
  // Modelo del usuario que estamos editando
  final Rx<UsuarioModel> usuario = UsuarioModel(
    rolId: 2, // Por defecto es empleado
    nombre: '',
    apellidoPaterno: '',
    apellidoMaterno: '',
    email: '',
    nss: '',
    contrasenaHash: '',
    fechaIngreso: DateTime.now(),
    estadoId: 1, // Activo por defecto
  ).obs;

  // Repository para operaciones de base de datos
  final UsuarioRepository _repository = Get.find<UsuarioRepository>();

  // Contraseña de confirmación
  final RxString confirmPassword = ''.obs;

  // Observaciones (manejadas por separado ya que es una tabla polimorfa)
  final observacionText = ''.obs;

  // Variables para controlar UI
  @override
  final showPassword = false.obs;

  // Catálogos
  late List<String> roles = ['Administrador'];
  //  = [
  //   'Admin',
  //   'Captador de Campo',
  //   'Promotor',
  //   'Recursos Humanos'
  // ];

  final List<String> tiposContrato = ['Temporal', 'Indefinido', 'Por Obra'];

  @override
  Future<void> onInit() async {
    super.onInit();
    // roles = await getRoles();
    // roles = await
    // Get.find<RolRepository>().getRolesNames().then((value) => roles = value);
    roles = await RolRepository().getRolesNames();
    // .getRolesNames().then((value) => roles = value);
    // print('antes de imprimir roles');
    print('Roles: $roles');
    // for (var rol in roles) {
    //   print(rol);
    // }
    resetForm();
  }

  int _getRolId(String? rolName) {
    if (rolName == null) return 0;
    print('Rol Name: $rolName');
    int rolId = 0;
    // RolRepository().findByNombre(rolName).then((value) => rolId = value!.id);
    rolId = roles.indexOf(rolName) + 1;
    // await RolRepository().findByNombre(rolName).then((value) => value!.id);
    print('Rol ID: $rolId');
    return rolId;
  }

  // Inicializar o resetear formulario
  @override
  void resetForm() {
    usuario.value = UsuarioModel(
      rolId: 2, // Por defecto es empleado
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      email: '',
      nss: '',
      contrasenaHash: '',
      fechaIngreso: DateTime.now(),
      estadoId: 1, // Activo por defecto
    );

    confirmPassword.value = '';
    observacionText.value = '';
    showPassword.value = false;
    formKey.currentState?.reset();
  }

  // Actualizar campos del modelo de usuario
  void updateUsuario({
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? email,
    String? telefono,
    String? nss,
    String? contrasenaHash,
    double? salario,
    String? tipoContrato,
    String? departamento,
    int? rolId,
    DateTime? fechaIngreso,
  }) {
    usuario.update((val) {
      if (val != null) {
        if (nombre != null) val.nombre = nombre;
        if (apellidoPaterno != null) val.apellidoPaterno = apellidoPaterno;
        if (apellidoMaterno != null) val.apellidoMaterno = apellidoMaterno;
        if (email != null) val.email = email;
        if (telefono != null) val.telefono = telefono;
        if (nss != null) val.nss = nss;
        if (contrasenaHash != null) val.contrasenaHash = contrasenaHash;
        if (salario != null) val.salario = salario;
        if (tipoContrato != null) val.tipoContrato = tipoContrato;
        if (departamento != null) val.departamento = departamento;
        if (rolId != null) val.rolId = rolId;
        if (fechaIngreso != null) val.fechaIngreso = fechaIngreso;
      }
    });
  }

  // Actualiza la confirmación de contraseña
  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  // Actualizar texto de observación
  void updateObservacion(String value) {
    observacionText.value = value;
  }

  // Muestra/oculta la contraseña
  @override
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  // Carga los datos de un usuario existente
  void loadUsuario(UsuarioModel model) {
    usuario.value = model;
    observacionText.value = model.departamento ?? '';
    update();
  }

  // VALIDACIONES

  String? validatePassword(String? value) {
    return validate_Password(value);
  }

  String? validateNSS(String? value) {
    return validate_NSS(value);
  }

  String? validateTipoContrato(String? value) {
    return validateInList(value, tiposContrato, fieldName: 'tipo de contrato');
  }

  String? validateSalario(String? value) {
    return validateSalary(value);
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value != usuario.value.contrasenaHash) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // GUARDAR EMPLEADO

  @override
  bool submitForm() {
    if (_validateForm()) {
      try {
        saveEmployee();
        return true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al guardar empleado: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return false;
  }

  Future<bool> saveEmployee() async {
    try {
      // El departamento se puede usar para guardar información temporal
      // que luego se puede mover a la tabla de observaciones
      if (observacionText.value.isNotEmpty) {
        usuario.update((val) {
          if (val != null) val.departamento = observacionText.value;
        });
      }

      // Guardar o actualizar el usuario
      final savedUser = usuario.value.id > 0
          ? await _repository.update(usuario.value)
          : await _repository.createEmployee(usuario.value);

      if (savedUser.id > 0) {
        Get.snackbar(
          'Éxito',
          'Empleado guardado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        // También podrías guardar la observación en su tabla correspondiente aquí

        return true;
      } else {
        throw Exception('No se pudo guardar el empleado');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validar tipo contrato
    if (usuario.value.tipoContrato == null ||
        usuario.value.tipoContrato!.isEmpty) {
      Get.snackbar(
        'Error',
        'Debe seleccionar un tipo de contrato',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validar contraseña y confirmación
    if (usuario.value.id == 0 && // Solo para nuevos usuarios
        usuario.value.contrasenaHash != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'Las contraseñas no coinciden',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
