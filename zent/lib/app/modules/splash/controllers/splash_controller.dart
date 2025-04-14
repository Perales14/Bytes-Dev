import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../data/services/session_service.dart';

class SplashController extends GetxController {
  final SessionService _sessionService = Get.find<SessionService>();
  final RxString loadingMessage = 'Inicializando...'.obs;
  final RxBool isLoggingOut = false.obs;

  final List<String> _loadingMessages = [
    'Inicializando...',
    'Cargando datos...',
    'Preparando aplicación...',
    'Casi listo...',
  ];

  final List<String> _loggingOutMessages = [
    'Cerrando sesión...',
    'Eliminando datos temporales...',
    'Finalizando sesión...',
  ];

  final List<String> _loginSuccessMessages = [
    'Inicio de sesión exitoso',
    'Preparando tu perfil...',
    'Cargando tu área de trabajo...',
    'Bienvenido a ZENT',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    int messageIndex = 0;

    final bool loggingOut = Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['loggingOut'] == true;

    final bool loginSuccess = Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['loginSuccess'] == true;

    isLoggingOut.value = loggingOut;

    final List<String> messageList;
    if (loggingOut) {
      messageList = _loggingOutMessages;
    } else if (loginSuccess) {
      messageList = _loginSuccessMessages;
    } else {
      messageList = _loadingMessages;
    }

    loadingMessage.value = messageList.first;

    final messageTimer =
        Stream.periodic(const Duration(milliseconds: 800), (i) {
      messageIndex = (messageIndex + 1) % messageList.length;
      return messageList[messageIndex];
    }).listen((message) {
      loadingMessage.value = message;
    });

    if (loggingOut) {
      await _handleLogout();
    } else if (loginSuccess) {
      await Future.delayed(const Duration(seconds: 2));
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }

    final bool isLoggedIn = _sessionService.isAuthenticated;

    messageTimer.cancel();

    Get.offAllNamed(isLoggedIn ? Routes.HOME : Routes.LOGIN);
  }

  Future<void> _handleLogout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _sessionService.logout();
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
