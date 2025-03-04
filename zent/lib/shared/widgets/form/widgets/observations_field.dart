import 'package:flutter/material.dart';
import 'package:zent/shared/widgets/form/widgets/base_form_field.dart';

class ObservationsField extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  const ObservationsField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<ObservationsField> createState() => _ObservacionesFieldState();
}

class _ObservacionesFieldState extends State<ObservationsField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: _processBulletPoints(widget.initialValue));
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _processBulletPoints(String text) {
    if (text.isEmpty) return '';

    List<String> lines = text.split('\n');
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isNotEmpty && !lines[i].startsWith('• ')) {
        lines[i] = '• ${lines[i]}';
      }
    }
    return lines.join('\n');
  }

  void _handleTextChange() {
    final text = _controller.text;
    final selection = _controller.selection;

    // Check if Enter was pressed
    if (selection.baseOffset > 0 &&
        selection.baseOffset <= text.length &&
        text[selection.baseOffset - 1] == '\n') {
      String newText = '';
      List<String> lines = text.split('\n');

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].isNotEmpty && !lines[i].startsWith('• ')) {
          lines[i] = '• ${lines[i]}';
        }
      }

      newText = lines.join('\n');

      if (newText != text) {
        final int diff = newText.length - text.length;
        _controller.value = TextEditingValue(
          text: newText,
          selection:
              TextSelection.collapsed(offset: selection.baseOffset + diff),
        );
      }
    }

    // Notify parent of changes
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: theme.textTheme.bodyMedium,
      decoration: BaseFormField.buildInputDecoration(
        theme: theme,
      ).copyWith(
        hintText: 'Agregar observaciones...',
        hintStyle: TextStyle(color: theme.hintColor),
      ),
    );
  }
}
