import 'package:get/get.dart';
import 'package:zent/app/data/services/project_context_service.dart';
import 'package:zent/app/data/services/project_service.dart';
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
    _initializeBaseServices();

    _initializeControllers();

    _initializeSecondaryServices();
  }

  // Inicializa los servicios fundamentales que son requisitos para otros componentes
  void _initializeBaseServices() {
    Get.put(SessionService(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(ProjectContextService(),
        permanent: true); // Nuevo servicio de contexto de proyecto
  }

  // Inicializa controladores que dependen de servicios fundamentales
  void _initializeControllers() {
    Get.put(SidebarController(), permanent: true);
  }

  // Inicializa servicios secundarios y repositorios
  void _initializeSecondaryServices() {
    Get.lazyPut(() => UserService(), fenix: true);
    // Services
    Get.put(ProjectService(), permanent: true);
    Get.lazyPut(() => SupabaseDatabase(), fenix: true);
    Get.lazyPut(() => ConnectivityHelper(), fenix: true);
    Get.lazyPut(() => FileRepository(), fenix: true);
  }
}
