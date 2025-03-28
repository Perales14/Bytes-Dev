import 'package:get/get.dart';
import 'package:zent/app/modules/clients/bindings/clients_binding.dart';
import 'package:zent/app/modules/clients/views/clients_view.dart';
import '../app/modules/employees/bindings/employees_binding.dart';
import '../app/modules/employees/views/employees_view.dart';
import '../app/modules/home/bindings/home_binding.dart';
import '../app/modules/home/views/home_view.dart';
import '../app/modules/providers/bindings/providers_binding.dart';
import '../app/modules/providers/views/providers_view.dart';
// <<<<<<< HEAD:zent/lib/Core/routes/app_pages.dart

// import '../../modules/home/bindings/home_binding.dart';
// import '../../modules/home/views/home_view.dart';
// // =======
// import '../modules/home/bindings/home_binding.dart';
// import '../modules/home/views/home_view.dart;
// >>>>>>> d3646bcf6827b705d965e15306787007e56dff12:zent/lib/routes/app_pages.dart

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYEES,
      page: () => const EmployeesView(),
      binding: EmployeesBinding(),
    ),
    GetPage(
      name: _Paths.CLIENTS,
      page: () => const ClientsView(),
      binding: ClientsBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDERS,
      page: () => const ProvidersView(),
      binding: ProvidersBinding(),
    ),
  ];
}
