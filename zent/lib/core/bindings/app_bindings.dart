import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/sidebar_controller.dart';
import 'package:zent/app/shared/controllers/theme_controller.dart';

import '../../app/data/providers/supabase/supabase_database.dart';
import '../../app/data/repositories/file_repository.dart';
import '../../app/data/services/session_service.dart';
import '../../app/data/services/user_service.dart';
import '../../app/data/utils/connectivity_helper.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Inicializar primero los servicios fundamentales
    // IMPORTANTE: SessionService debe inicializarse ANTES del SidebarController
    _initializeBaseServices();

    // Controladores que dependen de servicios
    _initializeControllers();

    // Servicios secundarios y repositorios
    _initializeSecondaryServices();
  }

  /// Inicializa los servicios fundamentales que son requisitos para otros componentes
  void _initializeBaseServices() {
    // Asegurar que SessionService esté disponible antes que cualquier otro componente
    Get.put(SessionService(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }

  /// Inicializa controladores que dependen de servicios fundamentales
  void _initializeControllers() {
    // SidebarController depende de SessionService, por lo que debe inicializarse después
    Get.put(SidebarController(), permanent: true);
  }

  /// Inicializa servicios secundarios y repositorios
  void _initializeSecondaryServices() {
    Get.lazyPut(() => UserService(), fenix: true);
    Get.lazyPut(() => SupabaseDatabase(), fenix: true);
    Get.lazyPut(() => ConnectivityHelper(), fenix: true);
    Get.lazyPut(() => FileRepository(), fenix: true);
  }
}
