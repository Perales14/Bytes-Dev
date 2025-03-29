import 'package:get/get.dart';
import '../../../data/services/provider_service.dart';
import '../../../data/services/observation_service.dart';
import '../../../data/services/address_service.dart';
import '../../../data/services/specialty_service.dart';
import '../../../data/services/state_service.dart';
import '../controllers/providers_controller.dart';

class ProvidersBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    if (!Get.isRegistered<ProviderService>()) {
      Get.lazyPut<ProviderService>(() => ProviderService());
    }

    if (!Get.isRegistered<ObservationService>()) {
      Get.lazyPut<ObservationService>(() => ObservationService());
    }

    if (!Get.isRegistered<AddressService>()) {
      Get.lazyPut<AddressService>(() => AddressService());
    }

    if (!Get.isRegistered<SpecialtyService>()) {
      Get.lazyPut<SpecialtyService>(() => SpecialtyService());
    }

    if (!Get.isRegistered<StateService>()) {
      Get.lazyPut<StateService>(() => StateService());
    }

    Get.lazyPut<ProvidersController>(() => ProvidersController());
  }
}
