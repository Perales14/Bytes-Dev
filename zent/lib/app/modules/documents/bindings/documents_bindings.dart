import 'package:get/get.dart';
import '../../../data/services/file_service.dart';
import '../../../data/services/session_service.dart';
import '../controllers/documents_controller.dart';

/// Binding para los documentos de un proyecto
class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FileService>()) {
      Get.lazyPut<FileService>(() => FileService(), fenix: true);
    }

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(SessionService(), permanent: true);
    }
    // if (!Get.isRegistered<DocumentsController>()) {
    //   Get.lazyPut<DocumentsController>(() => DocumentsController(),
    //       fenix: true);
    // }
  }
}
