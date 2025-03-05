import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zent/controllers/sidebar_controller.dart';
import 'package:zent/controllers/theme_controller.dart';
import 'package:zent/data/sources/local/interfaces/i_local_datasource.dart';
import 'package:zent/data/sources/local/sqlite_datasource.dart';
import 'package:zent/data/sources/remote/interfaces/i_remote_datasource.dart';
import 'package:zent/data/sources/remote/supabase_datasource.dart';
import 'package:zent/data/repositories/interfaces/i_direccion_repository.dart';
import 'package:zent/data/repositories/direccion_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Controladores globales de la aplicación
    Get.put(ThemeController(), permanent: true);
    Get.put(SidebarController(), permanent: true);

    // Estado de conectividad observado con Rx
    Get.put<Rx<ConnectivityResult>>(
        Rx<ConnectivityResult>(ConnectivityResult.none),
        permanent: true);

    // Configurar listener de conectividad
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          Get.find<Rx<ConnectivityResult>>().value = result;
        } as void Function(List<ConnectivityResult> event)?);

    // Fuentes de datos
    Get.lazyPut<ILocalDataSource>(
      () => SQLiteDataSource(),
      fenix: true,
    );

    Get.lazyPut<IRemoteDataSource>(
      () => SupabaseDataSource(Supabase.instance.client),
      fenix: true,
    );

    // Repositorios
    Get.lazyPut<IDireccionRepository>(
      () => DireccionRepository(Get.find(), Get.find()),
      fenix: true,
    );

    // Aquí se registrarían los demás repositorios
    // Get.lazyPut<IEspecialidadRepository>(...
    // Get.lazyPut<IEstadoRepository>(...
  }
}
