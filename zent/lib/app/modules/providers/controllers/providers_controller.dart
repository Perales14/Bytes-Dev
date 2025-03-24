import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../data/repositories/proveedor_repository.dart';
import '../../../data/repositories/especialidad_repository.dart';

class ProvidersController extends GetxController {
  // Lista reactiva de proveedores
  final providers = <ProveedorModel>[].obs;
  final filtro = ''.obs;
  final TextEditingController textController = TextEditingController();

  // Estado de carga
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Caché para nombres de especialidades
  final especialidadesCache = <int, String>{}.obs;

  // Repositorios
  final ProveedorRepository _repository;
  final EspecialidadRepository _especialidadRepository;

  // Inyección de dependencia mediante constructor
  ProvidersController({
    ProveedorRepository? repository,
    EspecialidadRepository? especialidadRepository,
  })  : _repository = repository ?? Get.find<ProveedorRepository>(),
        _especialidadRepository =
            especialidadRepository ?? Get.find<EspecialidadRepository>();

  @override
  void onInit() {
    super.onInit();
    loadProviders();

    // Configurar listener para el filtro de texto
    textController.addListener(() {
      filtro.value = textController.text;
      filterProviders();
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Método para cargar el nombre de especialidad si no está en caché
  void loadEspecialidadIfNeeded(int especialidadId) async {
    if (!especialidadesCache.containsKey(especialidadId)) {
      especialidadesCache[especialidadId] = 'Cargando...';

      try {
        final especialidad =
            await _especialidadRepository.getById(especialidadId);
        especialidadesCache[especialidadId] = especialidad.nombre;
      } catch (e) {
        print('Error al cargar especialidad $especialidadId: $e');
        especialidadesCache[especialidadId] = 'Especialidad $especialidadId';
      }
    }
  }

  // Método para obtener el nombre de la especialidad (desde caché)
  String getEspecialidadNombre(int especialidadId) {
    return especialidadesCache[especialidadId] ?? 'Cargando...';
  }

  // Filtrar proveedores según texto ingresado
  void filterProviders() {
    if (filtro.isEmpty) {
      loadProviders();
      return;
    }

    try {
      final searchText = filtro.value.toLowerCase();
      final filteredProviders = providers.where((proveedor) {
        return proveedor.nombreEmpresa.toLowerCase().contains(searchText) ||
            (proveedor.contactoPrincipal?.toLowerCase().contains(searchText) ??
                false) ||
            (proveedor.tipoServicio?.toLowerCase().contains(searchText) ??
                false) ||
            (proveedor.email?.toLowerCase().contains(searchText) ?? false);
      }).toList();

      providers.assignAll(filteredProviders);
    } catch (e) {
      print('Error al filtrar proveedores: $e');
    }
  }

  // Cargar proveedores desde el repositorio
  void loadProviders() async {
    try {
      isLoading(true);
      hasError(false);

      // Usamos getAllActive() para asegurar que solo obtenemos proveedores activos
      final result = await _repository.getAllActive();
      print('Proveedores cargados: ${result.length}');
      providers.assignAll(result);

      // Precargamos los nombres de especialidades
      for (var provider in result) {
        loadEspecialidadIfNeeded(provider.especialidadId);
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar proveedores: $e');
      print('Error cargando proveedores: $e');
    } finally {
      isLoading(false);
    }
  }

  // Recargar datos
  void refreshData() {
    loadProviders();
  }

  // Verificar si hay proveedores
  bool providersEmpty() => providers.isEmpty;
}
