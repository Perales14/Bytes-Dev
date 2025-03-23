import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  get textController => null;

  void increment() => count.value++;
}
