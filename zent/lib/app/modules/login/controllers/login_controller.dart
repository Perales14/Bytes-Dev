import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../../../routes/app_pages.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/session_service.dart';
import '../../../shared/controllers/sidebar_controller.dart';

class LoginController extends GetxController {
  // Servicios
  final UserService _userService = Get.find<UserService>();
  final SessionService _sessionService = Get.find<SessionService>();

  // Variables observables para UI
  final RxBool isPasswordVisible = false.obs;
  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasEmailError = false.obs;
  final RxBool hasPasswordError = false.obs;
  final RxString emailErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;

  // Controladores y nodos de foco
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeFocusNodes();

    if (_sessionService.isAuthenticated) {
      Get.offAllNamed(Routes.HOME);
    }
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
  void _onPasswordFocusChange() =>
      isPasswordFocused.value = passwordFocusNode.hasFocus;
  void togglePasswordVisibility() => isPasswordVisible.toggle();

  // Genera diferentes variantes de hash para mayor compatibilidad
  List<String> _generatePasswordHashes(String password) {
    List<String> hashes = [];
    hashes.add(md5.convert(utf8.encode(password)).toString());
    hashes.add(md5.convert(utf8.encode(password.toLowerCase())).toString());
    hashes.add(password); // Contraseña sin procesar
    hashes.add(sha1.convert(utf8.encode(password)).toString());
    hashes.add(sha256.convert(utf8.encode(password)).toString());
    return hashes;
  }

  // Método principal para realizar login
  Future<void> login() async {
    _resetErrors();
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Intentar con hash MD5 primero
      final standardHash = md5.convert(utf8.encode(password)).toString();
      var result = await _userService.validateCredentials(email, standardHash,
          debugMode: true);

      // Si falla, probar con otros formatos
      if (!result['success'] && result['exists']) {
        final allHashes = _generatePasswordHashes(password);

        for (final hash in allHashes) {
          if (hash == standardHash) continue;
          result = await _userService.validateCredentials(email, hash);
          if (result['success']) break;
        }
      }

      if (!result['success']) {
        _handleAuthenticationError(result);
        return;
      }

      await _handleSuccessfulLogin(result);
    } catch (e) {
      _showErrorSnackbar('Error de autenticación',
          'Ha ocurrido un error al iniciar sesión. Por favor intenta nuevamente.');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthenticationError(Map<String, dynamic> result) {
    if (!result['exists']) {
      hasEmailError.value = true;
      emailErrorText.value = 'Usuario no encontrado';
    } else if (!result['validPassword']) {
      hasPasswordError.value = true;
      passwordErrorText.value = 'Contraseña incorrecta';
    }
  }

  Future<void> _handleSuccessfulLogin(Map<String, dynamic> result) async {
    await _sessionService.login(result['user']);

    final sidebarController = Get.find<SidebarController>();
    sidebarController
        .updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);

    Get.offAllNamed('/splash', arguments: {'loginSuccess': true});
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    bool isValid = true;

    if (emailController.text.trim().isEmpty) {
      hasEmailError.value = true;
      emailErrorText.value = 'El email es requerido';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      hasEmailError.value = true;
      emailErrorText.value = 'Ingrese un email válido';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      hasPasswordError.value = true;
      passwordErrorText.value = 'La contraseña es requerida';
      isValid = false;
    }

    return isValid;
  }

  void _resetErrors() {
    hasEmailError.value = false;
    hasPasswordError.value = false;
    emailErrorText.value = '';
    passwordErrorText.value = '';
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
