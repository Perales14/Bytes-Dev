import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../../data/services/user_service.dart';
import '../../../data/services/session_service.dart';
import '../../../shared/controllers/sidebar_controller.dart';

class LoginController extends GetxController {
  // Services
  final UserService _userService = Get.find<UserService>();
  final SessionService _sessionService = Get.find<SessionService>();

  // Observable variables
  final RxBool isPasswordVisible = false.obs;
  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasEmailError = false.obs;
  final RxBool hasPasswordError = false.obs;
  final RxString emailErrorText = ''.obs;
  final RxString passwordErrorText = ''.obs;

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

    // Si ya hay una sesión activa, redirigir a la pantalla principal
    if (_sessionService.isAuthenticated) {
      Get.offAllNamed('/home');
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

  /// Convierte la contraseña en varias formas de hash para mayor compatibilidad
  List<String> _generatePasswordHashes(String password) {
    // Lista para almacenar los diferentes formatos de hash
    List<String> hashes = [];

    // MD5 hash (actual)
    hashes.add(md5.convert(utf8.encode(password)).toString());

    // MD5 hash con texto en minúsculas (por si la base de datos almacenó así)
    hashes.add(md5.convert(utf8.encode(password.toLowerCase())).toString());

    // Contraseña sin procesar (por si el hash se genera al guardar, no al comparar)
    hashes.add(password);

    // Otras variantes comunes
    hashes.add(sha1.convert(utf8.encode(password)).toString());
    hashes.add(sha256.convert(utf8.encode(password)).toString());

    return hashes;
  }

  /// Método principal para iniciar sesión con validación detallada
  Future<void> login() async {
    // Restablecer mensajes de error previos
    _resetErrors();

    // Validar campos vacíos
    if (!_validateInputs()) {
      return;
    }

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Intentar validar con el hash MD5 estándar primero
      final standardHash = md5.convert(utf8.encode(password)).toString();
      var result = await _userService.validateCredentials(email, standardHash,
          debugMode: true);

      // Si falla y el usuario existe, intentar con otros formatos de hash
      if (!result['success'] && result['exists']) {
        print(
            "Primer intento de autenticación fallido. Probando otros formatos de hash...");

        // Obtener todos los posibles formatos de hash
        final allHashes = _generatePasswordHashes(password);

        // Intentar con cada hash
        for (final hash in allHashes) {
          if (hash == standardHash)
            continue; // Saltar el hash estándar que ya probamos

          print("Probando con formato alternativo: ${hash.substring(0, 5)}...");
          result = await _userService.validateCredentials(email, hash);

          // Si encontramos coincidencia, salir del bucle
          if (result['success']) {
            print("Autenticación exitosa con formato alternativo");
            break;
          }
        }
      }

      // Manejar el resultado final
      if (!result['success']) {
        // Mostrar errores específicos
        if (!result['exists']) {
          hasEmailError.value = true;
          emailErrorText.value = 'Usuario no encontrado';
        } else if (!result['validPassword']) {
          hasPasswordError.value = true;
          passwordErrorText.value = 'Contraseña incorrecta';

          // Mostrar más información de depuración en la consola
          if (result.containsKey('debug')) {
            print('Datos de depuración: ${result['debug']}');
          }
        }
        return;
      }

      // Iniciar sesión si todo es correcto
      await _sessionService.login(result['user']);

      // Actualizar elementos del sidebar según el rol del usuario
      final sidebarController = Get.find<SidebarController>();
      sidebarController
          .updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);

      // Navegar a la pantalla principal
      Get.offAllNamed('/home');
    } catch (e) {
      print('Error durante autenticación: $e');
      Get.snackbar(
        'Error de autenticación',
        'Ha ocurrido un error al iniciar sesión. Por favor intenta nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para iniciar sesión con Google (Placeholder)
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      // Implementar lógica de Google Sign-In
      await Future.delayed(const Duration(seconds: 2)); // Simulación
    } finally {
      isLoading.value = false;
    }
  }

  /// Valida que los campos no estén vacíos
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

  /// Restablecer mensajes de error
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
