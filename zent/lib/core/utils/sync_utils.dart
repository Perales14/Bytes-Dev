import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zent/data/repositories/interfaces/i_direccion_repository.dart';

class SyncUtils {
  static Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<void> syncAllPendingData() async {
    if (!await checkConnectivity()) {
      print('Sin conexión a internet, sincronización pospuesta');
      return;
    }

    try {
      // Sincronizar todas las tablas que tienen datos pendientes
      final direccionRepo = Get.find<IDireccionRepository>();
      await direccionRepo.syncPendingToRemote();

      // Aquí se agregarían más repositorios a sincronizar
      // await Get.find<IOtroRepositorio>().syncPendingToRemote();

      print('Sincronización completa');
    } catch (e) {
      print('Error durante la sincronización: $e');
    }
  }

  // Programar sincronizaciones periódicas
  static void setupPeriodicSync(
      {Duration interval = const Duration(minutes: 15)}) {
    // Usar GetX workers para manejar esto
    ever(Get.find<Rx<ConnectivityResult>>(), (ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncAllPendingData();
      }
    });

    // También programar ejecuciones periódicas
    Future.delayed(interval, () async {
      await syncAllPendingData();
      setupPeriodicSync(interval: interval);
    });
  }
}
