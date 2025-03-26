import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/models/base_model.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import '../../../data/models/usuario_model.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../../../data/repositories/file_repository.dart';
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

  // Controladores de texto persistentes
  final nombreController = TextEditingController();
  final apellidoPaternoController = TextEditingController();
  final apellidoMaternoController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final nssController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final salarioController = TextEditingController();
  final departamentoController = TextEditingController();

  // Contraseña de confirmación
  final RxString confirmPassword = ''.obs;

  // Observaciones (manejadas por separado ya que es una tabla polimorfa)
  final observacionText = ''.obs;

  // Variables para controlar UI
  @override
  final showPassword = false.obs;

  // Catálogos
  late List<String> roles = ['Administrador'];
  final List<String> tiposContrato = ['Temporal', 'Indefinido', 'Por Obra'];

  @override
  Future<void> onInit() async {
    super.onInit();
    roles = await RolRepository().getRolesNames();
    print('Roles: $roles');
    resetForm();
  }

  @override
  void onClose() {
    // Liberar recursos de los controladores
    nombreController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    nssController.dispose();
    contrasenaController.dispose();
    confirmPasswordController.dispose();
    salarioController.dispose();
    departamentoController.dispose();
    super.onClose();
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

    // Inicializar los controladores con los valores iniciales
    nombreController.text = usuario.value.nombre;
    apellidoPaternoController.text = usuario.value.apellidoPaterno;
    apellidoMaternoController.text = usuario.value.apellidoMaterno ?? '';
    emailController.text = usuario.value.email;
    telefonoController.text = usuario.value.telefono ?? '';
    nssController.text = usuario.value.nss;
    contrasenaController.text = usuario.value.contrasenaHash;
    confirmPasswordController.text = confirmPassword.value;
    salarioController.text = usuario.value.salario?.toString() ?? '';
    departamentoController.text = usuario.value.departamento ?? '';

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

    // Trigger UI update and log values for debugging
    update();
    print('Usuario actualizado: ${usuario.value.toJson()}');
  }

  // Actualiza la confirmación de contraseña
  void updateConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  // Actualizar texto de observación
  void updateObservacion(String value) {
    observacionText.value = value;
  }

  int getRolId(String? rolName) {
    if (rolName == null) return 0;
    print('Rol Name: $rolName');
    int rolId = 0;
    // RolRepository().findByNombre(rolName).then((value) => rolId = value!.id);
    rolId = roles.indexOf(rolName) + 1;
    // await RolRepository().findByNombre(rolName).then((value) => value!.id);
    print('Rol ID: $rolId');
    return rolId;
  }

  // Preparar el modelo para guardarlo
  void prepareModelForSave() {
    usuario.update((val) {
      if (val != null) {
        val.nombre = nombreController.text;
        val.apellidoPaterno = apellidoPaternoController.text;
        val.apellidoMaterno = apellidoMaternoController.text.isEmpty
            ? null
            : apellidoMaternoController.text;
        val.email = emailController.text;
        val.telefono =
            telefonoController.text.isEmpty ? null : telefonoController.text;
        val.nss = nssController.text;
        val.contrasenaHash = contrasenaController.text;
        val.departamento = departamentoController.text.isEmpty
            ? null
            : departamentoController.text;
        val.salario = salarioController.text.isEmpty
            ? null
            : double.tryParse(salarioController.text);
      }
    });
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

    // Actualizar también los controladores
    nombreController.text = model.nombre;
    apellidoPaternoController.text = model.apellidoPaterno;
    apellidoMaternoController.text = model.apellidoMaterno ?? '';
    emailController.text = model.email;
    telefonoController.text = model.telefono ?? '';
    nssController.text = model.nss;
    contrasenaController.text = model.contrasenaHash;
    salarioController.text = model.salario?.toString() ?? '';
    departamentoController.text = model.departamento ?? '';

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
    if (validateForm()) {
      try {
        prepareModelForSave(); // Preparar el modelo antes de guardar
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

  // Método para guardar referencias de archivos
  Future<void> _saveFileReferences(
      List<Map<String, dynamic>> fileData, int employeeId) async {
    try {
      // Crea un repositorio para archivos si no lo tienes ya
      final fileRepository = Get.find<FileRepository>();

      for (var file in fileData) {
        await fileRepository.saveFile({
          ...file,
          'entity_id': employeeId,
          'entity_type': 'employee',
        });
      }
    } catch (e) {
      print('Error al guardar referencias de archivos: $e');
    }
  }

  Future<bool> saveEmployee() async {
    try {
      // El departamento se puede usar para guardar información temporal
      // que luego se puede mover a la tabla de observaciones
      print('formulario valido: ${validateForm()}');
      if (observacionText.value.isNotEmpty) {
        usuario.update((val) {
          if (val != null) val.departamento = observacionText.value;
        });
      }

      // Guardar o actualizar el usuario
      final savedUser = usuario.value.id > 0
          ? await _repository.update(usuario.value)
          : await _repository.createEmployee(usuario.value);

      if (files.isNotEmpty) {
        // upload

        final uploadedFiles =
            await uploadFilesToSupabase(files, usuario.value.id.toString());

        // Guarda las referencias de los archivos en la base de datos
        // SDA
        if (uploadedFiles.isNotEmpty) {
          await _saveFileReferences(uploadedFiles, usuario.value.id);
        }
      }

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

  bool validateForm() {
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

  // void addFile(FileData file) {
  //   files.add(file);
  //   // La siguiente línea fuerza una actualización en caso necesario
  //   files.refresh();
  // }
}
