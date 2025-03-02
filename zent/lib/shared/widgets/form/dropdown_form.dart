import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownForm extends StatelessWidget {
  final String label;
  final List<String> opciones;
  final String? value;
  final Function(String?) onChanged;

  const DropdownForm({
    required this.label,
    required this.opciones,
    required this.value,
    required this.onChanged,
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                'Seleccione $label',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              items: opciones.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.secondary,
              ),
              dropdownColor: theme.colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
