// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lightPrimary,
  scaffoldBackgroundColor: lightScaffoldBackground,
  colorScheme: const ColorScheme.light(
    primary: lightPrimary,
    onPrimary: textWhite,
    secondary: lightSecondary,
    surface: lightSurface,
    onSurface: lightOnSurface,
  ),
  textTheme: getLightTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: lightSurface,
    foregroundColor: lightOnSurface,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: lightSurface,
    elevation: 2,
    shadowColor: textBlack.withOpacity(0.2),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: lightSurface,
    hintStyle: TextStyle(color: lightHint),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkPrimary,
  scaffoldBackgroundColor: darkScaffoldBackground,
  colorScheme: const ColorScheme.dark(
    primary: darkPrimary,
    onPrimary: textWhite,
    secondary: darkSecondary,
    surface: darkSurface,
    onSurface: darkOnSurface,
  ),
  textTheme: getDarkTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkScaffoldBackground,
    foregroundColor: darkOnSurface,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: darkSurface,
    elevation: 2,
    shadowColor: Colors.white.withOpacity(0.2),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: darkSurface,
    hintStyle: TextStyle(color: darkHint),
  ),
);
