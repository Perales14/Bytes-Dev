import 'package:get/get.dart';
//import 'package:zent/controllers/auth_controller.dart'; // Importa tus controladores
import 'package:zent/controllers/sidebar_controller.dart';
//import 'package:zent/controllers/permissions_controller.dart';
//import 'package:zent/controllers/sync_controller.dart';
//import 'package:zent/services/connectivity_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    //Get.put<AuthController>(AuthController(), permanent: true); // Ejemplo
    Get.lazyPut<SidebarController>(() => SidebarController());
    //Get.put<PermissionsController>(PermissionsController(), permanent: true);
    //Get.put<SyncController>(SyncController(), permanent: true);
    //Get.lazyPut<ConnectivityService>(() => ConnectivityService());
    // Agrega más controladores aquí
  }
}
