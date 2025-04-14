import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../shared/controllers/theme_controller.dart';
import '../../../data/services/session_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Asegurar que el SessionService esté disponible
    if (!Get.isRegistered<SessionService>()) {
      Get.put(SessionService(), permanent: true);
    }

    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  }
}
