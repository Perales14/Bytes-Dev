import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/modules/home/controllers/home_controller.dart'; // Cambia 'tu_app' por 'zent'
import 'package:zent/shared/widgets/sidebar/sidebar.dart'; // Importa el Sidebar

class HomeView extends GetView<HomeController> {
  const HomeView({super.key}); // Usa Key? key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(  //  <--  Comentamos o eliminamos el AppBar
      //   title: const Text('HomeView'),
      //   centerTitle: true,
      // ),
      body: Row(
        // Usamos un Row para el Sidebar y el contenido principal
        children: [
          const Sidebar(), //  <--  Agregamos el Sidebar
          Expanded(
            //  <--  El contenido principal ocupa el resto del espacio
            child: Center(
              child: Text(
                'HomeView is working',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
