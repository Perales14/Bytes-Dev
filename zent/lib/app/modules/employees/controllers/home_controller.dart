import 'package:get/get.dart';
import 'package:zent/app/shared/factories/form_factory.dart';

class HomeController extends GetxController {
  // Tipo de formulario seleccionado actualmente
  final selectedFormType = FormType.employee.obs;

  final count = 0.obs;

  void increment() => count.value++;
}
