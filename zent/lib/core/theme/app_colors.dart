import 'package:flutter/material.dart';

class AppColors {
  // Colores para el Tema Claro
  final Color white;
  final Color black;
  final Color black5;
  final Color black20;
  final Color black40;
  final Color black60;
  final Color lightGrey;
  final Color tealBlue;
  final Color tealBlue80;

  // Colores para el Tema Oscuro
  final Color darkBlue;
  final Color darkPrimary;
  final Color darkSecondary;
  final Color accent;
  final Color greyF2;

  // Constructor para el tema claro
  AppColors.light()
      : white = const Color(0xFFFFFFFF),
        black = const Color(0xFF000000),
        black5 = const Color(0x0D000000),
        black20 = const Color(0x33000000),
        black40 = const Color(0x66000000),
        black60 = const Color(0x99000000),
        lightGrey = const Color(0xFFF2F2F2),
        tealBlue = const Color(0xFF074073),
        tealBlue80 = const Color(0xCC074073),
        darkBlue = const Color(0xFF152840), // Aunque no se usen directamente
        darkPrimary = const Color(0xFF074073),
        darkSecondary = const Color(0xFF0B1A26),
        accent = const Color(0xFF266F8C),
        greyF2 = const Color(0xFFF2F2F2);

  // Constructor para el tema oscuro
  AppColors.dark()
      : white = const Color(0xFFFFFFFF), // Aunque no se usen directamente
        black = const Color(0xFF000000),
        black5 = const Color(0x0D000000),
        black20 = const Color(0x33000000),
        black40 = const Color(0x66000000),
        black60 = const Color(0x99000000),
        lightGrey = const Color(0xFFF2F2F2),
        tealBlue = const Color(0xFF074073),
        tealBlue80 = const Color(0xCC074073),
        darkBlue = const Color(0xFF152840),
        darkPrimary = const Color(0xFF074073),
        darkSecondary = const Color(0xFF0B1A26),
        accent = const Color(0xFF266F8C),
        greyF2 = const Color(0xFFF2F2F2);
}
