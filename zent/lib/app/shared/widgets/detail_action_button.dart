import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DetailActionType {
  edit,
  delete,
}

class DetailActionButton extends StatelessWidget {
  final DetailActionType type;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool showIcon;
  final String? customText;
  final String? confirmationTitle;
  final String? confirmationMessage;

  const DetailActionButton({
    required this.type,
    required this.onPressed,
    this.isOutlined = false,
    this.showIcon = true,
    this.customText,
    this.confirmationTitle,
    this.confirmationMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Configurar apariencia según el tipo
    final IconData buttonIcon = _getIcon();
    final Color buttonColor = _getColor(theme);
    final String buttonText = customText ?? _getDefaultText();

    return ElevatedButton(
      onPressed: () => _handlePress(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? theme.colorScheme.surface : buttonColor,
        foregroundColor: isOutlined ? buttonColor : _getOnColor(theme),
        // Aumentar padding para botones más grandes
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isOutlined ? BorderSide(color: buttonColor) : BorderSide.none,
        ),
        elevation: isOutlined ? 0 : 2,
        // Aumentar tamaño mínimo
        minimumSize: const Size(120, 48),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Icon(
              buttonIcon,
              // Forzar color blanco para iconos en botones no outlined
              color: isOutlined ? buttonColor : Colors.white,
              // Aumentar tamaño del icono
              size: 24,
            ),
          if (showIcon) const SizedBox(width: 10),
          Text(
            buttonText,
            style: theme.textTheme.labelLarge?.copyWith(
              // Color específico según tipo de botón
              color: isOutlined ? buttonColor : Colors.white,
              fontWeight: FontWeight.w500,
              // Aumentar tamaño del texto
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePress(BuildContext context) {
    // Solo mostrar diálogo de confirmación para acciones de eliminación
    if (type == DetailActionType.delete) {
      _showConfirmationDialog(context);
    } else {
      onPressed();
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);

    final bool confirmed = await Get.dialog<bool>(
          AlertDialog(
            title: Text(confirmationTitle ?? _getDefaultConfirmationTitle()),
            content:
                Text(confirmationMessage ?? _getDefaultConfirmationMessage()),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColor(theme),
                  foregroundColor: Colors.white, // Forzar color blanco
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  _getConfirmActionText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      onPressed();
    }
  }

  IconData _getIcon() {
    switch (type) {
      case DetailActionType.edit:
        return Icons.edit;
      case DetailActionType.delete:
        return Icons.delete;
    }
  }

  Color _getColor(ThemeData theme) {
    switch (type) {
      case DetailActionType.edit:
        return theme.colorScheme.primary;
      case DetailActionType.delete:
        return theme.colorScheme.error;
    }
  }

  Color _getOnColor(ThemeData theme) {
    return Colors.white; // Siempre texto blanco en botones con color
  }

  String _getDefaultText() {
    switch (type) {
      case DetailActionType.edit:
        return 'Modificar';
      case DetailActionType.delete:
        return 'Eliminar';
    }
  }

  String _getDefaultConfirmationTitle() {
    switch (type) {
      case DetailActionType.edit:
        return '¿Confirmar modificación?';
      case DetailActionType.delete:
        return '¿Confirmar eliminación?';
    }
  }

  String _getDefaultConfirmationMessage() {
    switch (type) {
      case DetailActionType.edit:
        return '¿Está seguro que desea modificar este elemento?';
      case DetailActionType.delete:
        return '¿Está seguro que desea eliminar este elemento? Esta acción no se puede deshacer.';
    }
  }

  String _getConfirmActionText() {
    switch (type) {
      case DetailActionType.edit:
        return 'Modificar';
      case DetailActionType.delete:
        return 'Eliminar';
    }
  }
}
