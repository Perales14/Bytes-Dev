import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../shared/controllers/theme_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  }
}
