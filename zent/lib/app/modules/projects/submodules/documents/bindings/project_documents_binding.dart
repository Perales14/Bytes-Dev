import 'package:get/get.dart';
import '../controllers/project_documents_controller.dart';
import '../../../../../data/services/project_service.dart';
import '../../../../../data/services/file_service.dart';
import '../../../../../data/services/session_service.dart';

/// Binding para los documentos de un proyecto
class ProjectDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    // Verificar que los servicios requeridos estén disponibles
    if (!Get.isRegistered<ProjectService>()) {
      Get.lazyPut<ProjectService>(() => ProjectService(), fenix: true);
    }

    if (!Get.isRegistered<FileService>()) {
      Get.lazyPut<FileService>(() => FileService(), fenix: true);
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(SessionService(), permanent: true);
    }

    // Registrar el controlador
    Get.lazyPut<ProjectDocumentsController>(
      () => ProjectDocumentsController(),
      fenix: true,
    );
  }
}
