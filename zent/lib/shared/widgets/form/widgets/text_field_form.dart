import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldForm extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final int? maxLines;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool autofocus;

  const TextFieldForm({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixIcon,
    this.focusNode,
    this.readOnly = false,
    this.autofocus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          style: theme.textTheme.bodyMedium,
          focusNode: focusNode,
          readOnly: readOnly,
          autofocus: autofocus,
          decoration: _buildInputDecoration(theme),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: _buildBorderStyle(
          theme, theme.colorScheme.secondary.withOpacity(0.6)),
      enabledBorder: _buildBorderStyle(
          theme, theme.colorScheme.secondary.withOpacity(0.4)),
      focusedBorder:
          _buildBorderStyle(theme, theme.colorScheme.secondary, width: 1.5),
      errorBorder:
          _buildBorderStyle(theme, theme.colorScheme.error, width: 1.5),
      suffixIcon: suffixIcon,
    );
  }

  OutlineInputBorder _buildBorderStyle(ThemeData theme, Color color,
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
