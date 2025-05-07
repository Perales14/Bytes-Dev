import 'package:get/get.dart';
import '../../../../../data/services/session_service.dart';
import '../controllers/project_dashboard_controller.dart';
import '../../../../../data/services/project_service.dart';
import '../../../../../data/services/project_context_service.dart';

/// Binding para el dashboard de un proyecto
class ProjectDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Verificar si el controlador ya existe y reemplazarlo si es necesario
    if (Get.isRegistered<ProjectDashboardController>()) {
      Get.delete<ProjectDashboardController>();
    }

    // Verificar que los servicios requeridos estén disponibles
    if (!Get.isRegistered<ProjectService>()) {
      Get.lazyPut<ProjectService>(() => ProjectService(), fenix: true);
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(SessionService(), permanent: true);
    }

    // Inyectar el controlador con fenix: true para asegurar que
    // se mantenga en memoria mientras sea necesario
    Get.lazyPut<ProjectDashboardController>(
      () => ProjectDashboardController(
        projectService: Get.find<ProjectService>(),
        projectContextService: Get.find<ProjectContextService>(),
      ),
      fenix: true,
    );
  }
}
