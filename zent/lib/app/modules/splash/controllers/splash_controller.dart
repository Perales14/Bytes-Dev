// Controlador para la pantalla de splash que gestiona la inicialización y cierre de sesión
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../data/services/session_service.dart';

class SplashController extends GetxController {
  // Servicios
  final SessionService _sessionService = Get.find<SessionService>();

  // Mensaje de carga observable
  final RxString loadingMessage = 'Inicializando...'.obs;

  // Indica si estamos en modo de cerrar sesión
  final RxBool isLoggingOut = false.obs;

  // Mensajes de carga por mostrar en secuencia
  final List<String> _loadingMessages = [
    'Inicializando...',
    'Cargando datos...',
    'Preparando aplicación...',
    'Casi listo...',
  ];

  // Mensajes específicos para cierre de sesión
  final List<String> _loggingOutMessages = [
    'Cerrando sesión...',
    'Eliminando datos temporales...',
    'Finalizando sesión...',
  ];

  // Mensajes para inicio de sesión exitoso
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

  // Inicializa la aplicación y muestra mensajes de carga en secuencia
  Future<void> _initializeApp() async {
    int messageIndex = 0;

    // Detectar el modo en que se está usando el splash
    final bool loggingOut = Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['loggingOut'] == true;

    final bool loginSuccess = Get.arguments != null &&
        Get.arguments is Map &&
        Get.arguments['loginSuccess'] == true;

    // Configurar el estado según el modo
    isLoggingOut.value = loggingOut;

    // Seleccionar la lista de mensajes adecuada según el modo
    final List<String> messageList;

    if (loggingOut) {
      messageList = _loggingOutMessages;
    } else if (loginSuccess) {
      messageList = _loginSuccessMessages;
    } else {
      messageList = _loadingMessages;
    }

    // Establecer el mensaje inicial
    loadingMessage.value = messageList.first;

    // Mostrar mensajes de carga en secuencia
    final messageTimer =
        Stream.periodic(const Duration(milliseconds: 800), (i) {
      messageIndex = (messageIndex + 1) % messageList.length;
      return messageList[messageIndex];
    }).listen((message) {
      loadingMessage.value = message;
    });

    // Procesamiento según el modo
    if (loggingOut) {
      await _handleLogout();
    } else if (loginSuccess) {
      // Para inicios de sesión exitosos, mostrar mensajes por un tiempo breve
      await Future.delayed(const Duration(seconds: 2));
    } else {
      // Simular un tiempo de carga para startup normal (mejora UX)
      await Future.delayed(const Duration(seconds: 2));
    }

    // Verificar si hay una sesión activa
    final bool isLoggedIn = _sessionService.isAuthenticated;

    // Detener el timer de mensajes
    messageTimer.cancel();

    // Navegar a la pantalla correspondiente según el estado de autenticación
    Get.offAllNamed(isLoggedIn ? Routes.HOME : Routes.LOGIN);
  }

  // Maneja el proceso de cierre de sesión
  Future<void> _handleLogout() async {
    try {
      // Pausa para que el usuario vea la animación de cierre de sesión
      await Future.delayed(const Duration(seconds: 1));

      // Limpiar datos de sesión
      await _sessionService.logout();

      // Pausa adicional para UX
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      // Incluso con error, continuaremos a la pantalla de login
      print('Error al cerrar sesión: $e');
    }
  }
}
