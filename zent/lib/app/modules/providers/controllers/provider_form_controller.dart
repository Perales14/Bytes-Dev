import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/direccion_model.dart';
import '../../../data/models/especialidad_model.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../data/repositories/direccion_repository.dart';
import '../../../data/repositories/proveedor_repository.dart';
import '../../../data/repositories/estado_repository.dart';
import '../../../data/repositories/especialidad_repository.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart';

class ProviderFormController extends BaseFormController {
  // Repositorios
  final ProveedorRepository _proveedorRepository =
      Get.find<ProveedorRepository>();
  final DireccionRepository _direccionRepository =
      Get.find<DireccionRepository>();
  final EstadoRepository _estadoRepository = Get.find<EstadoRepository>();
  final EspecialidadRepository _especialidadRepository =
      Get.find<EspecialidadRepository>();

  // Modelos
  final Rx<ProveedorModel> proveedor = ProveedorModel(
    especialidadId: 1, // Valor por defecto, debe actualizarse
    nombreEmpresa: '',
    estadoId: 1, // Activo por defecto
  ).obs;

  late DireccionModel direccion;

  // Control de UI
  final showDireccion = false.obs;
  final observacionText = ''.obs;

  // Controladores de texto persistentes
  final nombreEmpresaController = TextEditingController();
  final contactoPrincipalController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final rfcController = TextEditingController();

  // Controladores para dirección
  final calleController = TextEditingController();
  final numeroController = TextEditingController();
  final coloniaController = TextEditingController();
  final cpController = TextEditingController();
  final estadoController = TextEditingController();
  final paisController = TextEditingController();

  // Listas para dropdowns
  final RxList<EspecialidadModel> especialidades = <EspecialidadModel>[].obs;
  final tiposServicio =
      ['Consultoría', 'Insumos', 'Mantenimiento', 'Software'].obs;
  final condicionesPago =
      ['Contado', '15 días', '30 días', '45 días', '60 días'].obs;

  // Estado de carga
  final isLoadingEspecialidades = true.obs;
  final hasErrorEspecialidades = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProvider();
    _loadEspecialidades();
  }

  @override
  void onClose() {
    // Liberar recursos de los controladores
    nombreEmpresaController.dispose();
    contactoPrincipalController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    rfcController.dispose();
    calleController.dispose();
    numeroController.dispose();
    coloniaController.dispose();
    cpController.dispose();
    estadoController.dispose();
    paisController.dispose();
    super.onClose();
  }

  // Cargar especialidades desde la base de datos
  Future<void> _loadEspecialidades() async {
    try {
      isLoadingEspecialidades(true);
      hasErrorEspecialidades(false);

      // Obtener todas las especialidades desde la base de datos
      final result = await _especialidadRepository.getAll();
      print('Especialidades cargadas: ${result.length}');

      // Si no hay especialidades, agregar una por defecto para evitar errores
      if (result.isEmpty) {
        especialidades.add(EspecialidadModel(
          id: 1,
          nombre: 'General',
          descripcion: 'Especialidad por defecto',
        ));
      } else {
        especialidades.assignAll(result);
      }

      // Actualizar el modelo si es necesario
      if (proveedor.value.id == 0 && especialidades.isNotEmpty) {
        updateProveedor(especialidadId: especialidades.first.id);
      }
    } catch (e) {
      hasErrorEspecialidades(true);
      print('Error al cargar especialidades: $e');

      // Agregar una especialidad por defecto en caso de error
      especialidades.add(EspecialidadModel(
        id: 1,
        nombre: 'General',
        descripcion: 'Especialidad por defecto',
      ));
    } finally {
      isLoadingEspecialidades(false);
    }
  }

  // Inicializa los modelos con valores por defecto
  void _initializeProvider() {
    proveedor.value = ProveedorModel(
      especialidadId: especialidades.isNotEmpty ? especialidades.first.id : 1,
      nombreEmpresa: '',
      contactoPrincipal: '',
      telefono: '',
      email: '',
      rfc: '',
      tipoServicio: tiposServicio.isNotEmpty ? tiposServicio[0] : null,
      condicionesPago: condicionesPago.isNotEmpty ? condicionesPago[0] : null,
      idDireccion: null,
      estadoId: 1, // Activo por defecto
    );

    // Inicializar los controladores con los valores iniciales
    nombreEmpresaController.text = proveedor.value.nombreEmpresa;
    contactoPrincipalController.text = proveedor.value.contactoPrincipal ?? '';
    telefonoController.text = proveedor.value.telefono ?? '';
    emailController.text = proveedor.value.email ?? '';
    rfcController.text = proveedor.value.rfc ?? '';

    direccion = DireccionModel(
      calle: '',
      numero: '',
      colonia: '',
      cp: '',
      estado: '',
      pais: 'México', // Default
    );

    // Inicializar controladores de dirección
    calleController.text = direccion.calle;
    numeroController.text = direccion.numero;
    coloniaController.text = direccion.colonia;
    cpController.text = direccion.cp;
    estadoController.text = direccion.estado ?? '';
    paisController.text = direccion.pais ?? 'México';

    observacionText.value = '';
  }

  // Obtener la especialidad actual por ID
  EspecialidadModel? getCurrentEspecialidad() {
    try {
      return especialidades.firstWhere(
        (e) => e.id == proveedor.value.especialidadId,
      );
    } catch (e) {
      // Si no se encuentra, retornar la primera o null
      return especialidades.isNotEmpty ? especialidades.first : null;
    }
  }

  // El resto del código permanece igual, solo actualizamos los métodos necesarios
  // ...

  // Actualizar datos del proveedor
  void updateProveedor({
    int? especialidadId,
    String? nombreEmpresa,
    String? contactoPrincipal,
    String? telefono,
    String? email,
    String? rfc,
    String? tipoServicio,
    String? condicionesPago,
    int? idDireccion,
    int? estadoId,
  }) {
    proveedor.update((val) {
      if (val != null) {
        if (especialidadId != null) val.especialidadId = especialidadId;
        if (nombreEmpresa != null) val.nombreEmpresa = nombreEmpresa;
        if (contactoPrincipal != null)
          val.contactoPrincipal = contactoPrincipal;
        if (telefono != null) val.telefono = telefono;
        if (email != null) val.email = email;
        if (rfc != null) val.rfc = rfc;
        if (tipoServicio != null) val.tipoServicio = tipoServicio;
        if (condicionesPago != null) val.condicionesPago = condicionesPago;
        if (idDireccion != null) val.idDireccion = idDireccion;
        if (estadoId != null) val.estadoId = estadoId;
      }
    });
  }

  // Actualizar dirección
  void updateDireccion({
    String? calle,
    String? numero,
    String? colonia,
    String? cp,
    String? estado,
    String? pais,
  }) {
    try {
      direccion = DireccionModel(
        id: direccion.id,
        calle: calle ?? direccion.calle,
        numero: numero ?? direccion.numero,
        colonia: colonia ?? direccion.colonia,
        cp: cp ?? direccion.cp,
        estado: estado ?? direccion.estado,
        pais: pais ?? direccion.pais,
        createdAt: direccion.createdAt,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print("Error al actualizar dirección: $e");
    }
  }

  // Toggle para mostrar/ocultar dirección
  void toggleDireccion() {
    showDireccion.toggle();
  }

  // Actualizar texto de observación
  void updateObservacion(String value) {
    observacionText.value = value;
  }

  // VALIDACIONES

  String? validateRFC(String? value) {
    if (value == null || value.isEmpty) {
      return null; // RFC es opcional
    }

    // Regex para validar RFC
    final rfcRegExp = RegExp(
        r'^([A-ZÑ&]{3,4})(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))([A-Z\d]{2})([A\d])$');
    if (!rfcRegExp.hasMatch(value)) {
      return 'RFC inválido';
    }
    return null;
  }

  String? validateCP(String? value) {
    if (showDireccion.value && (value == null || value.isEmpty)) {
      return 'El código postal es requerido';
    }

    if (showDireccion.value && value != null && value.isNotEmpty) {
      // Validar formato de CP (5 dígitos en México)
      if (!RegExp(r'^\d{5}$').hasMatch(value)) {
        return 'Formato de CP inválido (5 dígitos)';
      }
    }
    return null;
  }

  String? validateTipoServicio(String? value) {
    return validateInList(value, tiposServicio, fieldName: 'tipo de servicio');
  }

  String? validateCondicionesPago(String? value) {
    return validateInList(value, condicionesPago,
        fieldName: 'condiciones de pago');
  }

  // GUARDAR PROVEEDOR

  @override
  bool submitForm() {
    if (_validateForm()) {
      try {
        prepareModelForSave(); // Preparar el modelo antes de guardar
        saveProveedorWithData();
        return true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al guardar proveedor: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return false;
  }

  Future<bool> saveProveedorWithData() async {
    try {
      int? direccionId;

      // 1. Si hay dirección activa, guardarla primero
      if (showDireccion.value) {
        if (_validateDireccion()) {
          final direccionGuardada =
              await _direccionRepository.create(direccion);
          if (direccionGuardada.id > 0) {
            direccionId = direccionGuardada.id;
          } else {
            Get.snackbar(
              'Error',
              'No se pudo guardar la dirección',
              snackPosition: SnackPosition.BOTTOM,
            );
            return false;
          }
        } else {
          return false;
        }
      }

      // 2. Actualizar proveedor con la dirección si existe
      if (direccionId != null) {
        proveedor.update((val) {
          if (val != null) val.idDireccion = direccionId;
        });
      }

      // 3. Guardar el proveedor
      final savedProveedor = await _proveedorRepository.create(proveedor.value);

      if (savedProveedor.id <= 0) {
        Get.snackbar(
          'Error',
          'No se pudo guardar el proveedor',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // 4. Si hay observación, guardarla (usando el campo contactoPrincipal temporalmente)
      if (observacionText.value.trim().isNotEmpty) {
        proveedor.update((val) {
          if (val != null) {
            val.contactoPrincipal = observacionText.value.trim();
          }
        });

        await _proveedorRepository.update(proveedor.value);
      }

      Get.snackbar(
        'Éxito',
        'Proveedor guardado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }

  // Validar dirección
  bool _validateDireccion() {
    if (!showDireccion.value) return true;

    if (direccion.calle.isEmpty) {
      Get.snackbar('Error', 'La calle es requerida');
      return false;
    }

    if (direccion.numero.isEmpty) {
      Get.snackbar('Error', 'El número es requerido');
      return false;
    }

    if (direccion.colonia.isEmpty) {
      Get.snackbar('Error', 'La colonia es requerida');
      return false;
    }

    if (direccion.cp.isEmpty) {
      Get.snackbar('Error', 'El código postal es requerido');
      return false;
    }

    // Validar formato de CP
    if (!RegExp(r'^\d{5}$').hasMatch(direccion.cp)) {
      Get.snackbar('Error', 'Formato de CP inválido (5 dígitos)');
      return false;
    }

    return true;
  }

  bool _validateForm() {
    // Validar todos los campos del formulario
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validaciones específicas
    if (proveedor.value.nombreEmpresa.isEmpty) {
      Get.snackbar(
        'Error de validación',
        'El nombre de la empresa es requerido',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    _initializeProvider();
    showDireccion.value = false;
  }

  // Preparar el modelo para guardarlo
  void prepareModelForSave() {
    proveedor.update((val) {
      if (val != null) {
        val.nombreEmpresa = nombreEmpresaController.text;
        val.contactoPrincipal = contactoPrincipalController.text.isEmpty
            ? null
            : contactoPrincipalController.text;
        val.telefono =
            telefonoController.text.isEmpty ? null : telefonoController.text;
        val.email = emailController.text.isEmpty ? null : emailController.text;
        val.rfc = rfcController.text.isEmpty ? null : rfcController.text;
      }
    });

    direccion = DireccionModel(
      id: direccion.id,
      calle: calleController.text,
      numero: numeroController.text,
      colonia: coloniaController.text,
      cp: cpController.text,
      estado: estadoController.text.isEmpty ? null : estadoController.text,
      pais: paisController.text.isEmpty ? null : paisController.text,
      createdAt: direccion.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
