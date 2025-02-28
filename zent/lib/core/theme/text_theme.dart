// core/theme/text_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

TextTheme getLightTextTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.montserrat(
      // Titulo
      color: textBlack,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 0.83,
      letterSpacing: 3.60,
    ),
    headlineMedium: GoogleFonts.montserrat(
      // Encabezado 1
      color: textBlack,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.25,
    ),
    headlineSmall: GoogleFonts.montserrat(
      // Encabezado 2
      color: textBlack,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.montserrat(
      // Encabezado 3
      color: textBlack,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: GoogleFonts.montserrat(
      // Encabezado 4
      color: textGrey60,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.montserrat(
      // Subtitulo 1
      color: textGrey60,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.montserrat(
      // Subtitulo 2
      color: textGrey40,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: GoogleFonts.montserrat(
      // Subtitulo 3 (bodySmall)
      color: lightScaffoldBackground,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}

TextTheme getDarkTextTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.montserrat(
      // Titulo
      color: textWhite,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 0.83,
      letterSpacing: 3.60,
    ),
    headlineMedium: GoogleFonts.montserrat(
      // Encabezado 1
      color: textWhite,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.25,
    ),
    headlineSmall: GoogleFonts.montserrat(
      // Encabezado 2
      color: textWhite,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.montserrat(
      // Encabezado 3
      color: textWhite,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: GoogleFonts.montserrat(
      // Encabezado 4
      color: textGrey60,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.montserrat(
      // Subtitulo 1
      color: textGreyF2,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.montserrat(
      // Subtitulo 2
      color: textGreyF2.withOpacity(0.6),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: GoogleFonts.montserrat(
      // Subtitulo 3 (bodySmall)
      color: textGreyF2,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}
