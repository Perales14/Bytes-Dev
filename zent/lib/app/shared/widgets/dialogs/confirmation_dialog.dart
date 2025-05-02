import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelButtonText = 'Cancelar',
    this.confirmButtonText = 'Confirmar',
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final isDark = theme.brightness == Brightness.dark;

    final Color primaryColor = theme.colorScheme.primary;
    final Color backgroundColor = isDark
        ? theme.colorScheme.surface.withOpacity(0.9)
        : theme.colorScheme.surface;
    final Color textColor =
        isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurface;
    final Color cancelButtonColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryColor.withOpacity(0.5), width: 1),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
            if (onCancel != null) onCancel!();
          },
          style: TextButton.styleFrom(
            backgroundColor: cancelButtonColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            cancelButtonText,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(result: true);
            if (onConfirm != null) onConfirm!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            confirmButtonText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
    );
  }

  // Método estático para mostrar el diálogo fácilmente
  static Future<bool?> show({
    required String title,
    required String message,
    String cancelButtonText = 'Cancelar',
    String confirmButtonText = 'Confirmar',
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(
      ConfirmationDialog(
        title: title,
        message: message,
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText,
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
    );
  }
}
