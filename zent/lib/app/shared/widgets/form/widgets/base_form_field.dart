import 'package:flutter/material.dart';

class BaseFormField {
  static InputDecoration buildInputDecoration({
    required ThemeData theme,
    Widget? suffixIcon,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border:
          buildBorderStyle(theme, theme.colorScheme.secondary.withOpacity(0.6)),
      enabledBorder:
          buildBorderStyle(theme, theme.colorScheme.secondary.withOpacity(0.4)),
      focusedBorder:
          buildBorderStyle(theme, theme.colorScheme.secondary, width: 1.5),
      errorBorder: buildBorderStyle(theme, theme.colorScheme.error, width: 1.5),
      suffixIcon: suffixIcon,
    );
  }

  static OutlineInputBorder buildBorderStyle(ThemeData theme, Color color,
      {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}
