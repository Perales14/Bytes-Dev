import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../shared/models/form_config.dart';
import '../controllers/activity_form_controller.dart';
import '../../../../../data/models/activity_model.dart';
import 'activity_form.dart';

class AddActivityDialog extends StatefulWidget {
  final Function onSaveSuccess;
  final ActivityModel? activity;
  final bool isEditing;

  const AddActivityDialog({
    required this.onSaveSuccess,
    this.activity,
    this.isEditing = false,
    super.key,
  });

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  late final ActivityFormController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ActivityFormController());

    if (widget.activity != null) {
      controller.loadActivity(widget.activity!);
    }
  }

  @override
  void dispose() {
    Get.delete<ActivityFormController>();
    super.dispose();
  }

  void _handleCancel() {
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleSubmit() async {
    try {
      final isValid = controller.submitForm();
      if (isValid) {
        // Llamar al callback de éxito
        widget.onSaveSuccess();

        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
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
            event.logicalKey == LogicalKeyboardKey.escape) {
          _handleCancel();
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
              maxWidth: 900,
              maxHeight: size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ActivityForm(
                controller: controller,
                config: FormConfig(
                  title:
                      widget.isEditing ? 'EDITAR ACTIVIDAD' : 'NUEVA ACTIVIDAD',
                  primaryButtonText: widget.isEditing ? 'GUARDAR' : 'AGREGAR',
                ),
                onCancel: _handleCancel,
                onSubmit: _handleSubmit,
              );
            }),
          ),
        ),
      ),
    );
  }
}
