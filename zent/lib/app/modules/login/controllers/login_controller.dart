import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final textController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isEmailFocused = false.obs;
  final isPasswordFocused = false.obs;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void onInit() {
    super.onInit();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });

    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    final email = textController.text;
    print("Email: $email");
    // Aquí va tu lógica de autenticación
  }

  void loginWithGoogle() {
    print("Iniciando sesión con Google...");
    // Aquí va la lógica de Google Sign-In
  }
}

