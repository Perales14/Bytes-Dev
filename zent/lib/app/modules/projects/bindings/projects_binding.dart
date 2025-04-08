import 'package:get/get.dart';
import '../controllers/projects_controller.dart';

class ProjectsBinding extends Bindings {
  @override
  void dependencies() {
    // Register controller
    Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
  }
}
