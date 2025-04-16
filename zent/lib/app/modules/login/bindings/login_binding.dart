import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../data/services/session_service.dart';
import '../../../data/services/user_service.dart';
import '../../../shared/controllers/theme_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Servicios
    if (!Get.isRegistered<SessionService>()) {
      Get.put(SessionService(), permanent: true);
    }

    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut(() => UserService(), fenix: true);
    }

    // Controladores
    Get.lazyPut<LoginController>(() => LoginController());

    if (!Get.isRegistered<ThemeController>()) {
      Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    }
  }
}
