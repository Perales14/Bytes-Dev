import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/modules/home/controllers/home_controller.dart';
import 'package:zent/shared/widgets/layout/app_layout.dart'; // Importar el layout común

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Panel Principal', // Título de la página
      // showBackButton: false, // No es necesario, es false por defecto
      // Puedes añadir acciones adicionales si lo necesitas
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.notifications),
      //     onPressed: () => {},
      //   ),
      // ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'HomeView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
