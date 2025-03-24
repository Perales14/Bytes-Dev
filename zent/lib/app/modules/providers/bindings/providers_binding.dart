import 'package:get/get.dart';
import '../../../data/repositories/direccion_repository.dart';
import '../../../data/repositories/estado_repository.dart';
import '../../../data/repositories/proveedor_repository.dart';
import '../../../data/repositories/especialidad_repository.dart';
import '../controllers/providers_controller.dart';

class ProvidersBinding extends Bindings {
  @override
  void dependencies() {
    // Registramos los repositorios (eliminar duplicados)
    Get.lazyPut<ProveedorRepository>(() => ProveedorRepository());
    Get.lazyPut<DireccionRepository>(() => DireccionRepository());
    Get.lazyPut<EstadoRepository>(() => EstadoRepository());
    Get.lazyPut<EspecialidadRepository>(() => EspecialidadRepository());

    // Luego el controlador que depende de los repositorios
    Get.lazyPut<ProvidersController>(() => ProvidersController());
  }
}
