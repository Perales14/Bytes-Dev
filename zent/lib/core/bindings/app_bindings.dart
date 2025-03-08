import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/sidebar_controller.dart';
import 'package:zent/app/shared/controllers/theme_controller.dart';

import '../../app/data/providers/sqlite/sqlite_database.dart';
import '../../app/data/providers/supabase/supabase_database.dart';
import '../../app/data/repositories/usuario_repository.dart';
import '../../app/data/services/sync_service.dart';
import '../../app/data/utils/connectivity_helper.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Controladores globales de la aplicación
    Get.put(ThemeController(), permanent: true);
    Get.put(SidebarController(), permanent: true);

    Get.lazyPut(() => SQLiteDatabase());
    Get.lazyPut(() => SupabaseDatabase());
    Get.lazyPut(() => ConnectivityHelper());
    Get.lazyPut(() => SyncService());

    // Repositories
    Get.lazyPut(() => UsuarioRepository());
  }
}
