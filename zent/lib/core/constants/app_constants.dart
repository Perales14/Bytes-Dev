class AppConstants {
  //Esto es el ejemplo de una clase de constantes que se puede usar en toda la aplicación
  //Si no se necesita una clase de constantes, se puede borrar este archivo
  // Configuración de la aplicación
  static const String appName = 'Zent';
  static const String appVersion = '1.0.0';

  // Rutas de navegación
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  // Valores predeterminados
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Tamaños para UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;

  // Mensajes comunes
  static const String errorGenerico = 'Ha ocurrido un error inesperado';
  static const String sinConexion = 'No hay conexión a internet';
}
