// Binding para inyección de dependencias del módulo de login
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../data/services/session_service.dart';
import '../../../data/services/user_service.dart';
import '../../../shared/controllers/theme_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Asegurar que los servicios necesarios estén disponibles
    if (!Get.isRegistered<SessionService>()) {
      Get.put(SessionService(), permanent: true);
    }

    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut(() => UserService(), fenix: true);
    }

    // Registrar controladores
    Get.lazyPut<LoginController>(() => LoginController());

    // Asegurar que ThemeController esté disponible
    if (!Get.isRegistered<ThemeController>()) {
      Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    }
  }
}
