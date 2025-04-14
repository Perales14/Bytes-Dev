import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controlador para gestionar el tema de la aplicación
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // Estado del tema (claro u oscuro)
  final RxBool _isDarkMode = false.obs;

  // Getter para el estado del tema
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  /// Carga la preferencia de tema guardada
  void _loadThemePreference() {
    // Por defecto tema claro - se implementará persistencia en futuras versiones
    _isDarkMode.value = false;
  }

  /// Alterna entre tema claro y oscuro
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _updateTheme();
  }

  /// Establece específicamente el tema claro u oscuro
  void setTheme({required bool darkMode}) {
    _isDarkMode.value = darkMode;
    _updateTheme();
  }

  /// Actualiza el tema en la aplicación
  void _updateTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    // Aquí se añadirá código para persistir la preferencia
  }
}
