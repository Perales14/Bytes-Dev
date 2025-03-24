import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  final textController = TextEditingController();
  void increment() => count.value++;
}
