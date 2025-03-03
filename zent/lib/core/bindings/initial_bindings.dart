import 'package:get/get.dart';
import 'package:zent/controllers/sidebar_controller.dart';
import 'package:zent/controllers/theme_controller.dart';
// Import other controllers as needed

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Controladores globales de la aplicación
    Get.put(ThemeController(), permanent: true);
    Get.put(SidebarController(), permanent: true);
    // No necesitamos inicializar FormController aquí
    // Los controladores de formularios específicos se inicializan
    // bajo demanda en el FormFactory o DynamicForm
  }
}
