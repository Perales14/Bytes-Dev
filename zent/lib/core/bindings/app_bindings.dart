import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/sidebar_controller.dart';
import 'package:zent/app/shared/controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Controladores globales de la aplicación
    Get.put(ThemeController(), permanent: true);
    Get.put(SidebarController(), permanent: true);

    // Aquí se registrarían los demás repositorios
    // Get.lazyPut<IEspecialidadRepository>(...
    // Get.lazyPut<IEstadoRepository>(...
  }
}
