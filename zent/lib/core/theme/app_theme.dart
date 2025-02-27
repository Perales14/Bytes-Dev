import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zent/core/theme/app_colors.dart'; //  Cambia 'tu_app' por 'zent'
import 'package:zent/core/theme/text_theme.dart';
import 'package:get/get.dart';

// Clase abstracta base para los temas
abstract class AppTheme extends ThemeExtension<AppTheme> {
  final AppColors colors;
  ThemeData get themeData;

  AppTheme(this.colors);

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

  // Debes implementar copyWith y lerp (requeridos por ThemeExtension)
  @override
  AppTheme copyWith({AppColors? colors}) {
    return _ConcreteAppTheme(
      colors ?? this.colors,
    );
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) {
      return this;
    }
    return _ConcreteAppTheme(
      t > 0.5 ? other.colors : colors,
    );
  }
}

// Clase CONCRETA interna para usar con copyWith y lerp
class _ConcreteAppTheme extends AppTheme {
  _ConcreteAppTheme(super.colors);

  @override
  ThemeData get themeData => throw UnimplementedError(); // No se usa
}

// Tema Claro
class LightTheme extends AppTheme {
  LightTheme() : super(AppColors.light());

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
      textTheme: CustomTextTheme.lightTextTheme(colors),
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
      extensions: <ThemeExtension<dynamic>>[
        this, // <--  IMPORTANTE:  Registra la instancia
      ],
    ));
  }

  //Se debe implentar los sig. métodos debido a que se extiende de ThemeExtensions
  @override
  AppTheme copyWith({AppColors? colors}) {
    return LightTheme();
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! LightTheme) {
      return this;
    }
    return LightTheme();
  }
}

// Tema Oscuro
class DarkTheme extends AppTheme {
  DarkTheme() : super(AppColors.dark());

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
      textTheme: CustomTextTheme.darkTextTheme(colors),
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
      extensions: <ThemeExtension<dynamic>>[
        this, // <--  IMPORTANTE:  Registra la instancia
      ],
    ));
  }

  //Se debe implentar los sig. métodos debido a que se extiende de ThemeExtensions
  @override
  AppTheme copyWith({AppColors? colors}) {
    return DarkTheme();
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! DarkTheme) {
      return this;
    }
    return DarkTheme();
  }
}
