import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Usamos Rx para manejar reactivamente el tema
  Rx<ThemeMode> theme = ThemeMode.system.obs;

  @override
  void onInit() async {
    super.onInit();
    // Cargamos la preferencia de tema al iniciar
    theme.value = await _loadThemeFromPreferences();
    update();
  }

  Future<ThemeMode> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? -1;

    // Devolvemos el tema según la preferencia guardada
    if (themeIndex == 1) return ThemeMode.light;
    if (themeIndex == 2) return ThemeMode.dark;

    // Si no hay preferencia, usamos el tema del sistema
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveThemeToPreferences(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', themeMode == ThemeMode.light ? 1 : 2);
  }

  void toggleTheme() {
    theme.value =
        theme.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveThemeToPreferences(theme.value);
    update();
  }

  // Método para establecer modo sistema
  void setSystemTheme() {
    theme.value = ThemeMode.system;
    _saveThemeToPreferences(theme.value);
    update();
  }
}
