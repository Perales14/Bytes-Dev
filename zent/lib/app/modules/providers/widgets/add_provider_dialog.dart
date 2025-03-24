import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/provider_form_controller.dart';
import '../../../shared/models/form_config.dart';
import '../../../data/repositories/direccion_repository.dart';
import '../../../data/repositories/estado_repository.dart';
import '../../../data/repositories/proveedor_repository.dart';
import 'provider_form.dart';

class AddProviderDialog extends StatefulWidget {
  final Function onSaveSuccess;

  const AddProviderDialog({
    required this.onSaveSuccess,
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
    // Asegurar que todos los repositorios estén registrados
    if (!Get.isRegistered<ProveedorRepository>()) {
      Get.lazyPut(() => ProveedorRepository());
    }

    if (!Get.isRegistered<DireccionRepository>()) {
      Get.lazyPut(() => DireccionRepository());
    }

    if (!Get.isRegistered<EstadoRepository>()) {
      Get.lazyPut(() => EstadoRepository());
    }

    // Inicializamos el controlador
    controller = Get.put(ProviderFormController());
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
