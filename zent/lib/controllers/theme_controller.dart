import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zent/core/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // Usa ThemeMode directamente, ya no necesitas AppTheme
  late ThemeData _currentThemeData; //  <--  Usa ThemeData directamente
  ThemeData get currentThemeData =>
      _currentThemeData; // <--  Getter para ThemeData

  final _box = GetStorage();
  final _themeKey = 'themeMode';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeIndex = _box.read<int>(_themeKey) ?? 0;

    switch (themeIndex) {
      case 1:
        _themeMode.value = ThemeMode.light;
        _currentThemeData = LightTheme().themeData; // <--  Guarda el ThemeData
        break;
      case 2:
        _themeMode.value = ThemeMode.dark;
        _currentThemeData = DarkTheme().themeData; // <--  Guarda el ThemeData
        break;
      default:
        _themeMode.value = ThemeMode.system;
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        _currentThemeData = brightness == Brightness.dark
            ? DarkTheme().themeData
            : LightTheme().themeData; // <--  Guarda el ThemeData
    }
    update(); // Notifica a los listeners
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;

    switch (mode) {
      case ThemeMode.light:
        _currentThemeData = LightTheme().themeData; //  <-- Guarda el ThemeData
        await _box.write(_themeKey, 1);
        break;
      case ThemeMode.dark:
        _currentThemeData = DarkTheme().themeData; //  <-- Guarda el ThemeData
        await _box.write(_themeKey, 2);
        break;
      case ThemeMode.system:
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        _currentThemeData = brightness == Brightness.dark
            ? DarkTheme().themeData
            : LightTheme().themeData; // <-- Guarda el ThemeData

        await _box.write(_themeKey, 0);

        break;
    }
    Get.changeThemeMode(mode); // Cambia el ThemeMode
    Get.changeTheme(_currentThemeData); //  <--  Aplica el ThemeData COMPLETO
    update(); // Notifica a GetX
  }

  void toggleTheme() {
    setThemeMode(
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
