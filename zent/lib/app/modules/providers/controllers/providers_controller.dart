import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/provider_model.dart';
import '../../../data/services/provider_service.dart';
import '../../../data/services/specialty_service.dart';
import '../widgets/add_provider_dialog.dart';
import '../widgets/provider_details_dialog.dart';

class ProvidersController extends GetxController {
  // Reactive provider list
  final providers = <ProviderModel>[].obs;
  final filter = ''.obs;
  final TextEditingController textController = TextEditingController();

  // Loading states
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Cache for specialty names
  final specialtiesCache = <int, String>{}.obs;

  // Services
  final ProviderService _providerService;
  final SpecialtyService _specialtyService;

  // Dependency injection through constructor
  ProvidersController({
    ProviderService? providerService,
    SpecialtyService? specialtyService,
  })  : _providerService = providerService ?? Get.find<ProviderService>(),
        _specialtyService = specialtyService ?? Get.find<SpecialtyService>();

  @override
  void onInit() {
    super.onInit();
    loadProviders();

    // Setup listener for text filter
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

  // Load specialty name if not in cache
  void loadSpecialtyIfNeeded(int specialtyId) async {
    if (!specialtiesCache.containsKey(specialtyId)) {
      specialtiesCache[specialtyId] = 'Loading...';

      try {
        final specialty = await _specialtyService.getSpecialtyById(specialtyId);
        if (specialty != null) {
          specialtiesCache[specialtyId] = specialty.name;
        } else {
          specialtiesCache[specialtyId] = 'Specialty $specialtyId';
        }
      } catch (e) {
        print('Error loading specialty $specialtyId: $e');
        specialtiesCache[specialtyId] = 'Specialty $specialtyId';
      }
    }
  }

  // Get specialty name from cache
  String getSpecialtyName(int specialtyId) {
    return specialtiesCache[specialtyId] ?? 'Loading...';
  }

  // Filter providers based on search text
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
      print('Error filtering providers: $e');
    }
  }

  // Load providers from service
  void loadProviders() async {
    try {
      isLoading(true);
      hasError(false);

      // Use getActiveProviders to ensure we only get active providers
      final result = await _providerService.getActiveProviders();
      print('Providers loaded: ${result.length}');
      providers.assignAll(result);

      // Preload specialty names
      for (var provider in result) {
        loadSpecialtyIfNeeded(provider.specialtyId);
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error loading providers: $e');
      print('Error loading providers: $e');
    } finally {
      isLoading(false);
    }
  }

  // Reload data
  void refreshData() {
    loadProviders();
  }

  // Check if there are no providers
  bool providersEmpty() => providers.isEmpty;

  // Show provider details dialog
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
              // First close the dialog
              Navigator.of(context).pop();
              // Then navigate to edit page or show another dialog
              _showEditProviderDialog(context, provider);
            },
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not find provider information',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Helper method to show edit dialog
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

  // Helper method to get provider by ID
  ProviderModel getProviderById(int id) {
    try {
      return providers.firstWhere((provider) => provider.id == id);
    } catch (e) {
      throw Exception('Provider with ID $id not found');
    }
  }
}
