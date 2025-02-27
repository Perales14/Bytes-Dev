 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/routes/app_pages.dart';  // Importar las rutas generadas
import 'package:zent/modules/home/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App con GetX',
      initialRoute: AppPages.FORM, // Ruta inicial
      getPages: AppPages.routes, // Rutas de la aplicación
    );
  }
} 