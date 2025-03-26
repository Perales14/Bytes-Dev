import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';
import 'app/shared/controllers/sidebar_controller.dart';
import 'app/shared/controllers/theme_controller.dart';
import 'core/bindings/app_bindings.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';

void main() async {
  // Asegúrate que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.setTitle("Home");

  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Initialize controllers
  final ThemeController themeController = Get.put(ThemeController());
  final SidebarController sidebarController = Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'Zent',
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: AppBindings(),
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeController.theme.value,
        ));
  }
}
