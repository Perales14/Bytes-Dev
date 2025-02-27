import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/core/bindings/initial_bindings.dart'; // Cambia 'tu_app'
import 'package:zent/core/theme/app_theme.dart';
import 'package:zent/routes/app_pages.dart'; //  Usa la ruta correcta
import 'package:zent/controllers/theme_controller.dart'; // <-- Importa ThemeController
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeController = Get.put(ThemeController());

  MyApp({super.key}); // <-- Instancia ThemeController

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Zent',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      theme: LightTheme().themeData, // <--  Tema claro por defecto
      darkTheme: DarkTheme().themeData, // <--  Tema oscuro
      themeMode:
          themeController.themeMode, // <--  Usa el ThemeMode del controlador
      // No uses theme y darkTheme directamente si usas themeMode
    );
  }
}
