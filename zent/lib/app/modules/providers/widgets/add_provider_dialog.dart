import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/provider_model.dart';
import '../controllers/provider_form_controller.dart';
import '../../../shared/models/form_config.dart';
import 'provider_form.dart';

class AddProviderDialog extends StatefulWidget {
  final Function onSaveSuccess;
  final ProviderModel? provider;

  const AddProviderDialog({
    required this.onSaveSuccess,
    this.provider,
    super.key,
  });

  @override
  State<AddProviderDialog> createState() => _AddProviderDialogState();
}

class _AddProviderDialogState extends State<AddProviderDialog> {
  late final ProviderFormController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProviderFormController());

    // Cargar proveedor si estamos en modo edición
    if (widget.provider != null) {
      controller.loadProvider(widget.provider!);
    }
  }

  @override
  void dispose() {
    controller.resetForm();
    Get.delete<ProviderFormController>();
    super.dispose();
  }

  void _handleCancel() {
    controller.resetForm();
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  void _handleSubmit() async {
    try {
      // Obtener el resultado del formulario
      final isValid = controller.submitForm();

      if (isValid) {
        // Cerrar el diálogo primero, antes de que se elimine el controlador
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        // Después llamar al callback de éxito
        widget.onSaveSuccess();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isEditing = widget.provider != null;

    return RawKeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape &&
            mounted &&
            Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.05,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ProviderForm(
              controller: controller,
              config: FormConfig.provider,
              onCancel: _handleCancel,
              onSubmit: _handleSubmit,
              submitText: isEditing ? 'GUARDAR' : 'AGREGAR',
            ),
          ),
        ),
      ),
    );
  }
}
