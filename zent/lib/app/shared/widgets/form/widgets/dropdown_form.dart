import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownForm extends StatelessWidget {
  final String label;
  final List<String> opciones;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const DropdownForm({
    required this.label,
    required this.opciones,
    required this.value,
    required this.onChanged,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Validar que el value esté en la lista de opciones
    final String? validValue =
        (value != null && opciones.contains(value)) ? value : null;

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.secondary.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: validValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
            hint: Text(
              'Seleccione $label',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            items: opciones.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            icon: Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.secondary,
            ),
            dropdownColor: theme.colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
