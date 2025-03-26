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

    // Inicializamos el controlador
    controller = Get.put(ProviderFormController());

    // Si estamos en modo edición, cargamos los datos del proveedor
    if (widget.provider != null) {
      controller.loadProvider(widget.provider!);
    }
  }

  @override
  void dispose() {
    Get.delete<ProviderFormController>();
    super.dispose();
  }

  void _handleCancel() {
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  void _handleSubmit() async {
    try {
      final isValid = controller.submitForm();

      if (isValid) {
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
          widget.onSaveSuccess();
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            ),
          ),
        ),
      ),
    );
  }
}
