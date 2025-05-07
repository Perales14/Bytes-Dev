import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';
import '../../../../../data/services/activity_service.dart';
import '../../../../../data/services/project_service.dart';
import '../../../../../data/services/session_service.dart';

/// Binding para las actividades de un proyecto
class ProjectActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    // Verificar que los servicios requeridos estén disponibles
    if (!Get.isRegistered<ActivityService>()) {
      Get.lazyPut<ActivityService>(() => ActivityService(), fenix: true);
    }

    if (!Get.isRegistered<ProjectService>()) {
      Get.lazyPut<ProjectService>(() => ProjectService(), fenix: true);
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(SessionService(), permanent: true);
    }

    // Registrar el controlador
    Get.lazyPut<ProjectActivitiesController>(
      () => ProjectActivitiesController(),
      fenix: true,
    );
  }
}
