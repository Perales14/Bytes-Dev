import 'package:get/get.dart';
import 'package:zent/modules/form/bindings/form_binding.dart';
import 'package:zent/modules/form/views/form_view.dart';
import 'package:zent/modules/home/bindings/home_binding.dart';
import 'package:zent/modules/home/views/home_view.dart';
// <<<<<<< HEAD:zent/lib/Core/routes/app_pages.dart

// import '../../modules/home/bindings/home_binding.dart';
// import '../../modules/home/views/home_view.dart';
// // =======
// import '../modules/home/bindings/home_binding.dart';
// import '../modules/home/views/home_view.dart';
// >>>>>>> d3646bcf6827b705d965e15306787007e56dff12:zent/lib/routes/app_pages.dart

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const FORM = Routes.FORM;
  static const INITIAL = Routes.HOME;
  // static const FORM = 
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FORM,
      page: () => const FormView(),
      binding: FormBinding(),
    ),
  ];
  
}