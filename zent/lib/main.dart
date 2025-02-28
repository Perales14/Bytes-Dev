import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/core/bindings/initial_bindings.dart';
import 'package:zent/core/theme/app_theme.dart';
import 'package:zent/routes/app_pages.dart';
import 'package:zent/controllers/theme_controller.dart';
import 'package:zent/controllers/sidebar_controller.dart'; // Importar SidebarController
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());
  final SidebarController sidebarController = Get.put(SidebarController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Zent',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.theme.value,
    );
  }
}
