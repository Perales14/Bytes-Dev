import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerForm extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final String? Function(DateTime?)? validator;
  final bool readOnly;
  final String? hint;

  const DatePickerForm({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
    this.readOnly = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    Future<void> selectDate() async {
      if (readOnly) return;

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                primary: theme.colorScheme.primary,
                onPrimary: theme.colorScheme.onPrimary,
                surface: theme.colorScheme.surface,
                onSurface: theme.colorScheme.onSurface,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        onDateSelected(picked);
      }
    }

    return FormField<DateTime>(
      validator: validator,
      initialValue: selectedDate,
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: label,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: theme.textTheme.titleSmall?.copyWith(
                      color: state.hasError
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    errorText: state.errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: state.hasError
                            ? theme.colorScheme.error
                            : theme.colorScheme.outline,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? dateFormat.format(selectedDate!)
                            : hint ?? 'Seleccionar fecha',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: selectedDate != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
