import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zent/core/theme/app_colors.dart'; // Cambia 'tu_app' y la ruta
import 'package:zent/core/theme/text_theme.dart';
import 'package:get/get.dart';

// Clase abstracta base para los temas
abstract class AppTheme {
  final AppColors colors; // <--  Agregamos la propiedad colors
  ThemeData get themeData;

  AppTheme(this.colors); // Constructor modificado

  ThemeData _applyFont(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(theme.textTheme),
      primaryTextTheme: GoogleFonts.montserratTextTheme(theme.primaryTextTheme),
      appBarTheme: theme.appBarTheme.copyWith(
        titleTextStyle:
            GoogleFonts.montserrat(textStyle: theme.appBarTheme.titleTextStyle),
      ),
    );
  }

  // Método estático para cambiar el tema (ejemplo)
  static void changeTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}

// Tema Claro
class LightTheme extends AppTheme {
  LightTheme() : super(AppColors.light()); // <--  Pasamos la instancia correcta

  @override
  ThemeData get themeData {
    final base = ThemeData.light();
    return _applyFont(base.copyWith(
      brightness: Brightness.light,
      primaryColor: colors.white,
      scaffoldBackgroundColor: colors.lightGrey,
      colorScheme: base.colorScheme.copyWith(
        primary: colors.tealBlue,
        onPrimary: colors.white,
        secondary: colors.tealBlue,
        surface: colors.white,
        onSurface: colors.black,
        brightness: Brightness.light,
      ),
      textTheme:
          CustomTextTheme.lightTextTheme(colors), //Se le pasa el objeto colors
      appBarTheme: AppBarTheme(
        backgroundColor: colors.white,
        foregroundColor: colors.black,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colors.white,
        elevation: 2,
        shadowColor: colors.black20,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colors.tealBlue,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colors.white,
        hintStyle: TextStyle(color: colors.black40),
      ),
    ));
  }
}

// Tema Oscuro
class DarkTheme extends AppTheme {
  DarkTheme() : super(AppColors.dark()); // <--  Pasamos la instancia correcta

  @override
  ThemeData get themeData {
    final base = ThemeData.dark();
    return _applyFont(base.copyWith(
      brightness: Brightness.dark,
      primaryColor: colors.darkSecondary,
      scaffoldBackgroundColor: colors.darkBlue,
      colorScheme: base.colorScheme.copyWith(
        primary: colors.darkPrimary,
        onPrimary: colors.white,
        secondary: colors.accent,
        surface: colors.darkBlue,
        onSurface: colors.greyF2,
        brightness: Brightness.dark,
      ),
      textTheme:
          CustomTextTheme.darkTextTheme(colors), //Se le pasa el objeto colors
      appBarTheme: AppBarTheme(
        backgroundColor: colors.darkBlue,
        foregroundColor: colors.greyF2,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colors.darkSecondary,
        elevation: 2,
        shadowColor: Colors.white24,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colors.darkPrimary,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colors.darkSecondary,
        hintStyle: TextStyle(color: colors.greyF2.withOpacity(0.6)),
      ),
    ));
  }
}
