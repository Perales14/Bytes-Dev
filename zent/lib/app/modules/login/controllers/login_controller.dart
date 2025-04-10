import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Observable variables
  final RxBool isPasswordVisible = false.obs;
  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;
  final RxBool isLoading = false.obs;

  // Controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  
  // Focus nodes
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeFocusNodes();
  }

  void _initializeControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void _initializeFocusNodes() {
    emailFocusNode = FocusNode()..addListener(_onEmailFocusChange);
    passwordFocusNode = FocusNode()..addListener(_onPasswordFocusChange);
  }

  void _onEmailFocusChange() => isEmailFocused.value = emailFocusNode.hasFocus;
  void _onPasswordFocusChange() => isPasswordFocused.value = passwordFocusNode.hasFocus;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  Future<void> login() async {
    if (_validateInputs()) {
      isLoading.value = true;
      try {
        // Implementar lógica de login
        await Future.delayed(const Duration(seconds: 2)); // Simulación
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      // Implementar lógica de Google Sign-In
      await Future.delayed(const Duration(seconds: 2)); // Simulación
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}

