import 'package:get/get.dart';
import '../../../data/repositories/proveedor_repository.dart';
import '../../../data/repositories/observacion_repository.dart';
import '../../../data/repositories/direccion_repository.dart';
import '../../../data/repositories/especialidad_repository.dart';
import '../../../data/repositories/estado_repository.dart';
import '../controllers/providers_controller.dart';

class ProvidersBinding extends Bindings {
  @override
  void dependencies() {
    // Repositorios necesarios
    if (!Get.isRegistered<ProveedorRepository>()) {
      Get.lazyPut<ProveedorRepository>(() => ProveedorRepository());
    }

    if (!Get.isRegistered<ObservacionRepository>()) {
      Get.lazyPut<ObservacionRepository>(() => ObservacionRepository());
    }

    if (!Get.isRegistered<DireccionRepository>()) {
      Get.lazyPut<DireccionRepository>(() => DireccionRepository());
    }

    if (!Get.isRegistered<EspecialidadRepository>()) {
      Get.lazyPut<EspecialidadRepository>(() => EspecialidadRepository());
    }

    if (!Get.isRegistered<EstadoRepository>()) {
      Get.lazyPut<EstadoRepository>(() => EstadoRepository());
    }

    // Controlador
    Get.lazyPut<ProvidersController>(() => ProvidersController());
  }
}
