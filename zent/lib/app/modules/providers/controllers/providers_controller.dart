import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/provider_model.dart';
import '../../../data/services/provider_service.dart';
import '../../../data/services/specialty_service.dart';
import '../widgets/add_provider_dialog.dart';
import '../widgets/provider_details_dialog.dart';

class ProvidersController extends GetxController {
  // Listas reactivas y estados
  final providers = <ProviderModel>[].obs;
  final filter = ''.obs;
  final TextEditingController textController = TextEditingController();

  // Estados de carga
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Caché para nombres de especialidades
  final specialtiesCache = <int, String>{}.obs;

  // Servicios
  final ProviderService _providerService;
  final SpecialtyService _specialtyService;

  // Inyección de dependencias
  ProvidersController({
    ProviderService? providerService,
    SpecialtyService? specialtyService,
  })  : _providerService = providerService ?? Get.find<ProviderService>(),
        _specialtyService = specialtyService ?? Get.find<SpecialtyService>();

  @override
  void onInit() {
    super.onInit();
    loadProviders();

    // Configurar filtro de texto
    textController.addListener(() {
      filter.value = textController.text;
      filterProviders();
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Cargar proveedores desde el servicio
  void loadProviders() async {
    try {
      isLoading(true);
      hasError(false);

      final result = await _providerService.getActiveProviders();
      providers.assignAll(result);

      // Precargar nombres de especialidades
      for (var provider in result) {
        loadSpecialtyIfNeeded(provider.specialtyId);
      }
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

  // Filtrar proveedores según texto de búsqueda
  void filterProviders() {
    if (filter.isEmpty) {
      loadProviders();
      return;
    }

    try {
      final searchText = filter.value.toLowerCase();
      final filteredProviders = providers.where((provider) {
        return provider.companyName.toLowerCase().contains(searchText) ||
            (provider.mainContactName?.toLowerCase().contains(searchText) ??
                false) ||
            (provider.serviceType?.toLowerCase().contains(searchText) ??
                false) ||
            (provider.email?.toLowerCase().contains(searchText) ?? false);
      }).toList();

      providers.assignAll(filteredProviders);
    } catch (e) {
      // Manejo silencioso de errores
    }
  }

  // Verificar si no hay proveedores
  bool providersEmpty() => providers.isEmpty;

  // Cargar nombre de especialidad si no está en caché
  void loadSpecialtyIfNeeded(int specialtyId) async {
    if (!specialtiesCache.containsKey(specialtyId)) {
      specialtiesCache[specialtyId] = 'Cargando...';

      try {
        final specialty = await _specialtyService.getSpecialtyById(specialtyId);
        if (specialty != null) {
          specialtiesCache[specialtyId] = specialty.name;
        } else {
          specialtiesCache[specialtyId] = 'Especialidad $specialtyId';
        }
      } catch (e) {
        specialtiesCache[specialtyId] = 'Especialidad $specialtyId';
      }
    }
  }

  // Obtener nombre de especialidad desde caché
  String getSpecialtyName(int specialtyId) {
    return specialtiesCache[specialtyId] ?? 'Cargando...';
  }

  // Obtener proveedor por ID
  ProviderModel getProviderById(int id) {
    try {
      return providers.firstWhere((provider) => provider.id == id);
    } catch (e) {
      throw Exception('Provider with ID $id not found');
    }
  }

  // Mostrar detalles de proveedor
  void showProviderDetails(int providerId) {
    try {
      final provider = providers.firstWhere((p) => p.id == providerId);

      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) {
          return ProviderDetailsDialog(
            provider: provider,
            onEditPressed: () {
              Navigator.of(context).pop();
              _showEditProviderDialog(context, provider);
            },
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se ha encontrado información sobre el proveedor',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Método auxiliar para mostrar diálogo de edición
  void _showEditProviderDialog(BuildContext context, ProviderModel provider) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return AddProviderDialog(
          onSaveSuccess: () => refreshData(),
          provider: provider,
        );
      },
    );
  }

  // Marcar proveedor como inactivo
  Future<void> setProviderInactive(int id) async {
    try {
      await _providerService.setProviderInactive(id);
      refreshData();
    } catch (e) {
      hasError(true);
      errorMessage('Error al cambiar estado del proveedor: $e');
      throw Exception('Error al cambiar estado del proveedor: $e');
    }
  }
}
