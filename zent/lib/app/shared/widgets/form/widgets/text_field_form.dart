import 'package:flutter/material.dart';
import 'package:zent/app/shared/widgets/form/widgets/base_form_field.dart';

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
          decoration: BaseFormField.buildInputDecoration(
            theme: theme,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
