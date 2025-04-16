// Binding para el módulo Splash
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../data/services/session_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Asegurar que SessionService está disponible
    if (!Get.isRegistered<SessionService>()) {
      Get.put(SessionService(), permanent: true);
    }

    // Inicializar el controlador de Splash
    Get.put<SplashController>(SplashController());
  }
}
