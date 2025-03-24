import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../data/repositories/proveedor_repository.dart';

class ProvidersController extends GetxController {
  // Lista reactiva de proveedores
  final providers = <ProveedorModel>[].obs;
  final filtro = ''.obs;
  final TextEditingController textController = TextEditingController();

  // Estado de carga
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Repositorio
  final ProveedorRepository _repository;

  // Inyección de dependencia mediante constructor
  ProvidersController({ProveedorRepository? repository})
      : _repository = repository ?? Get.find<ProveedorRepository>();

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
      final result = await _repository.getAll();
      providers.assignAll(result);
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar proveedores: $e');
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
