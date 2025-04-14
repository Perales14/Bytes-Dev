// Controlador que gestiona la lógica de autenticación
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

  // Controladores para campos de texto
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // Nodos de foco para campos de texto
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeFocusNodes();

    // Verificar si ya hay sesión activa
    if (_sessionService.isAuthenticated) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // Inicializar controladores de texto
  void _initializeControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  // Inicializar nodos de foco
  void _initializeFocusNodes() {
    emailFocusNode = FocusNode()..addListener(_onEmailFocusChange);
    passwordFocusNode = FocusNode()..addListener(_onPasswordFocusChange);
  }

  // Actualizar estado de foco del email
  void _onEmailFocusChange() => isEmailFocused.value = emailFocusNode.hasFocus;

  // Actualizar estado de foco de la contraseña
  void _onPasswordFocusChange() =>
      isPasswordFocused.value = passwordFocusNode.hasFocus;

  // Alternar visibilidad de la contraseña
  void togglePasswordVisibility() => isPasswordVisible.toggle();

  // Genera diferentes variantes de hash para mayor compatibilidad
  List<String> _generatePasswordHashes(String password) {
    List<String> hashes = [];

    // Variantes comunes de hash
    hashes.add(md5.convert(utf8.encode(password)).toString());
    hashes.add(md5.convert(utf8.encode(password.toLowerCase())).toString());
    hashes.add(password); // Contraseña sin procesar
    hashes.add(sha1.convert(utf8.encode(password)).toString());
    hashes.add(sha256.convert(utf8.encode(password)).toString());

    return hashes;
  }

  // Método principal para realizar login
  Future<void> login() async {
    // Limpiar errores previos
    _resetErrors();

    // Validar campos antes de procesar
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Intentar con hash MD5 primero (más común)
      final standardHash = md5.convert(utf8.encode(password)).toString();
      var result = await _userService.validateCredentials(email, standardHash,
          debugMode: true);

      // Si falla y el usuario existe, probar con otros formatos
      if (!result['success'] && result['exists']) {
        final allHashes = _generatePasswordHashes(password);

        // Probar cada formato de hash
        for (final hash in allHashes) {
          if (hash == standardHash) continue; // Saltar el ya probado

          result = await _userService.validateCredentials(email, hash);
          if (result['success']) break;
        }
      }

      // Procesar resultado final
      if (!result['success']) {
        _handleAuthenticationError(result);
        return;
      }

      // Autenticación exitosa
      await _handleSuccessfulLogin(result);
    } catch (e) {
      _showErrorSnackbar('Error de autenticación',
          'Ha ocurrido un error al iniciar sesión. Por favor intenta nuevamente.');
    } finally {
      isLoading.value = false;
    }
  }

  // Maneja errores de autenticación
  void _handleAuthenticationError(Map<String, dynamic> result) {
    if (!result['exists']) {
      hasEmailError.value = true;
      emailErrorText.value = 'Usuario no encontrado';
    } else if (!result['validPassword']) {
      hasPasswordError.value = true;
      passwordErrorText.value = 'Contraseña incorrecta';
    }
  }

  // Procesa un login exitoso
  Future<void> _handleSuccessfulLogin(Map<String, dynamic> result) async {
    // Guardar sesión
    await _sessionService.login(result['user']);

    // Actualizar sidebar según el rol
    final sidebarController = Get.find<SidebarController>();
    sidebarController
        .updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);

    // Navegar a través de la pantalla de splash (con argumento de login exitoso)
    Get.offAllNamed('/splash', arguments: {'loginSuccess': true});
  }

  // Muestra snackbar de error
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Método placeholder para login con Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      // Implementación futura
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  // Valida los campos de email y contraseña
  bool _validateInputs() {
    bool isValid = true;

    // Validar email
    if (emailController.text.trim().isEmpty) {
      hasEmailError.value = true;
      emailErrorText.value = 'El email es requerido';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      hasEmailError.value = true;
      emailErrorText.value = 'Ingrese un email válido';
      isValid = false;
    }

    // Validar contraseña
    if (passwordController.text.isEmpty) {
      hasPasswordError.value = true;
      passwordErrorText.value = 'La contraseña es requerida';
      isValid = false;
    }

    return isValid;
  }

  // Restablece mensajes de error
  void _resetErrors() {
    hasEmailError.value = false;
    hasPasswordError.value = false;
    emailErrorText.value = '';
    passwordErrorText.value = '';
  }

  @override
  void onClose() {
    // Liberar recursos
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
