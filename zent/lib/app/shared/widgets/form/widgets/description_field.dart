import 'package:flutter/material.dart';
import 'package:zent/app/shared/widgets/form/widgets/base_form_field.dart';

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
    _controller.addListener(() => widget.onChanged(_controller.text));
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
      decoration: BaseFormField.buildInputDecoration(
        theme: theme,
      ).copyWith(
        hintText: 'Agregar descripción...',
        hintStyle: TextStyle(color: theme.hintColor),
      ),
    );
  }
}
