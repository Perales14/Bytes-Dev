import 'package:get/get.dart';
import 'package:zent/controllers/form_controller.dart';
import 'package:zent/controllers/sidebar_controller.dart';
import 'package:zent/controllers/theme_controller.dart';
// Import other controllers as needed

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(SidebarController());
    Get.put(FormController());
    // Add other controllers as needed
  }
}
