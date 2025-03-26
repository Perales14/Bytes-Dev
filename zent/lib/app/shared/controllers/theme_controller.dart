import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controlador que gestiona el tema de la aplicación.
///
/// Permite cambiar entre tema claro, oscuro y modo sistema,
/// guardando la preferencia del usuario.
class ThemeController extends GetxController {
  /// Clave utilizada para almacenar la preferencia de tema
  static const String _prefsKey = 'themeMode';

  /// Valores constantes para los modos de tema en preferencias
  static const int _lightThemeValue = 1;
  static const int _darkThemeValue = 2;

  /// Estado observable del tema actual
  final Rx<ThemeMode> theme = ThemeMode.system.obs;

  /// Inicializa el controlador cargando el tema guardado
  @override
  void onInit() async {
    super.onInit();
    theme.value = await _loadThemeFromPreferences();
    update();
  }

  /// Carga el tema desde las preferencias del usuario
  ///
  /// Retorna el ThemeMode guardado o el predeterminado si no hay preferencia
  Future<ThemeMode> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_prefsKey) ?? -1;

    // Devolvemos el tema según la preferencia guardada
    if (themeIndex == _lightThemeValue) return ThemeMode.light;
    if (themeIndex == _darkThemeValue) return ThemeMode.dark;

    // Si no hay preferencia, usamos el tema del sistema
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Guarda la preferencia de tema en almacenamiento persistente
  ///
  /// [themeMode] El modo de tema a guardar
  Future<void> _saveThemeToPreferences(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    final valueToSave =
        themeMode == ThemeMode.light ? _lightThemeValue : _darkThemeValue;

    await prefs.setInt(_prefsKey, valueToSave);
  }

  /// Alterna entre tema claro y oscuro
  ///
  /// Si el tema actual es oscuro, cambia a claro y viceversa
  void toggleTheme() {
    theme.value =
        theme.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveThemeToPreferences(theme.value);
    update();
  }

  /// Establece el tema al modo del sistema
  ///
  /// Usa el tema del sistema operativo (claro/oscuro)
  void setSystemTheme() {
    theme.value = ThemeMode.system;
    _saveThemeToPreferences(theme.value);
    update();
  }
}
