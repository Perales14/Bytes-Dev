import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DescriptionField extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  const DescriptionField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    // Add listener to notify parent of changes
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      maxLines: 15,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary.withOpacity(0.6),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.secondary,
            width: 1.5,
          ),
        ),
        hintText: 'Agregar descripción...',
        hintStyle: TextStyle(
          color: theme.hintColor,
        ),
      ),
    );
  }
}
