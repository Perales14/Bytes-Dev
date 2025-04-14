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
    // Controllers
    Get.put(ThemeController(), permanent: true);
    Get.put(SidebarController(), permanent: true);

    // Services
    Get.put(SessionService(), permanent: true);
    Get.lazyPut(() => UserService(), fenix: true);
    Get.lazyPut(() => SupabaseDatabase(), fenix: true);
    Get.lazyPut(() => ConnectivityHelper(), fenix: true);

    // Repositories
    Get.lazyPut(() => FileRepository(), fenix: true);
  }
}
