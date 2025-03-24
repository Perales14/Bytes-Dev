import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/direccion_model.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../data/repositories/direccion_repository.dart';
import '../../../data/repositories/proveedor_repository.dart';
import '../../../data/repositories/estado_repository.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart';

class ProviderFormController extends BaseFormController {
  // Repositorios
  final ProveedorRepository _proveedorRepository =
      Get.find<ProveedorRepository>();
  final DireccionRepository _direccionRepository =
      Get.find<DireccionRepository>();
  final EstadoRepository _estadoRepository = Get.find<EstadoRepository>();

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

  // Listas para dropdowns
  final RxList<Map<String, dynamic>> especialidades =
      <Map<String, dynamic>>[].obs;
  final tiposServicio =
      ['Consultoría', 'Insumos', 'Mantenimiento', 'Software'].obs;
  final condicionesPago =
      ['Contado', '15 días', '30 días', '45 días', '60 días'].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProvider();
    _loadEspecialidades();
  }

  // Cargar especialidades desde la base de datos
  void _loadEspecialidades() async {
    try {
      // Aquí deberías cargar las especialidades de tu base de datos
      // Por ahora usaremos datos de ejemplo
      especialidades.value = [
        {'id': 1, 'nombre': 'Construcción'},
        {'id': 2, 'nombre': 'Electricidad'},
        {'id': 3, 'nombre': 'Plomería'},
        {'id': 4, 'nombre': 'Informática'},
      ];
    } catch (e) {
      print('Error al cargar especialidades: $e');
    }
  }

  // Inicializa los modelos con valores por defecto
  void _initializeProvider() {
    proveedor.value = ProveedorModel(
      especialidadId: especialidades.isNotEmpty ? especialidades[0]['id'] : 1,
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

    direccion = DireccionModel(
      calle: '',
      numero: '',
      colonia: '',
      cp: '',
      estado: '',
      pais: 'México', // Default
    );

    observacionText.value = '';
  }

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
}
