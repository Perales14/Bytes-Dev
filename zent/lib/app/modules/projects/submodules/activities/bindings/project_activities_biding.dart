import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';
import '../../../../../data/services/activity_service.dart';

class ProjectActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar el servicio de actividades si aún no está registrado
    if (!Get.isRegistered<ActivityService>()) {
      Get.lazyPut<ActivityService>(() => ActivityService());
    }

    // Registrar el controlador de actividades
    Get.lazyPut<ProjectActivitiesController>(
      () => ProjectActivitiesController(),
    );
  }
}
