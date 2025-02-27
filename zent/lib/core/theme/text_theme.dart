import 'package:zent/core/theme/app_colors.dart'; //  <-- Importa AppColors
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextTheme {
  // Tema de texto para el modo claro
  static TextTheme lightTextTheme(AppColors colors) {
    // <--- Recibe AppColors
    return TextTheme(
      displayLarge: TextStyle(
        //  Titulo
        color: colors.black, // Usamos colors
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 0.83,
        letterSpacing: 3.60,
      ),
      headlineMedium: TextStyle(
        // Encabezado 1
        color: colors.black, // Usamos colors
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      headlineSmall: TextStyle(
        // Encabezado 2:
        color: colors.black, // Usamos colors
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        // Encabezado 3:
        color: colors.black, // Usamos colors
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        // Encabezado 4:
        color: colors.black60, // Usamos colors
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        // Subtitulo 1
        color: colors.black60, // Usamos colors
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        // Subtitulo 2:
        color: colors.black40, // Usamos colors
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        //bodySmall // Subtitulo 3:
        color: colors.lightGrey, // Usamos colors
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Tema de texto para el modo oscuro
  static TextTheme darkTextTheme(AppColors colors) {
    // <--- Recibe AppColors
    return TextTheme(
      displayLarge: TextStyle(
        // Titulo
        color: colors.white, // Usamos colors
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 0.83,
        letterSpacing: 3.60,
      ),
      headlineMedium: TextStyle(
        // Encabezado 1
        color: colors.white, // Usamos colors
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      headlineSmall: TextStyle(
          // Encabezado 2:
          color: colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600),
      titleMedium: TextStyle(
        // Encabezado 3:
        color: colors.white, // Usamos colors
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        // Encabezado 4:
        color: colors.black60, // Usamos colors
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        // Subtitulo 1
        color: colors.greyF2, // Usamos colors
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        // Subtitulo 2:
        color: colors.greyF2.withOpacity(0.6), // Usamos colors
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        //bodySmall// Subtitulo 3:
        color: colors.greyF2, // Usamos colors
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
