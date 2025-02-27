import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/core/theme/app_theme.dart'; // Cambia 'tu_app'
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  late AppTheme _currentTheme;
  AppTheme get currentTheme => _currentTheme;

  final _box = GetStorage();
  final _themeKey = 'themeMode'; // Clave para guardar en GetStorage

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    // Lee el valor de GetStorage.  Si no existe, usa 0 (system).
    final themeIndex = _box.read<int>(_themeKey) ?? 0;

    switch (themeIndex) {
      case 1:
        _themeMode.value = ThemeMode.light;
        _currentTheme = LightTheme();
        break;
      case 2:
        _themeMode.value = ThemeMode.dark;
        _currentTheme = DarkTheme();
        break;
      default:
        _themeMode.value = ThemeMode.system;
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        _currentTheme =
            brightness == Brightness.dark ? DarkTheme() : LightTheme();
    }
    update();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;

    switch (mode) {
      case ThemeMode.light:
        _currentTheme = LightTheme();
        await _box.write(_themeKey, 1); // Guarda 1 para light
        break;
      case ThemeMode.dark:
        _currentTheme = DarkTheme();
        await _box.write(_themeKey, 2); // Guarda 2 para dark
        break;
      case ThemeMode.system:
        _currentTheme =
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark
                ? DarkTheme()
                : LightTheme();
        await _box.write(_themeKey, 0); // Guarda 0 para system
        break;
    }
    Get.changeThemeMode(mode);
    Get.changeTheme(_currentTheme.themeData);
    update();
  }

  void toggleTheme() {
    setThemeMode(
      themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
