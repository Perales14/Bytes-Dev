import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../shared/models/form_config.dart';
import '../controllers/project_form_controller.dart';
import '../../../data/models/project_model.dart';
import 'project_form.dart';

class AddProjectDialog extends StatefulWidget {
  final Function onSaveSuccess;
  final ProjectModel? project;
  final bool isEditing;

  const AddProjectDialog({
    required this.onSaveSuccess,
    this.project,
    this.isEditing = false,
    super.key,
  });

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  late final ProjectFormController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProjectFormController());

    if (widget.project != null) {
      print('7iygu');
      print(widget.project!.clientId);
      print(widget.project!.managerId);
      print(widget.project!.providerId);


      controller.loadProject(widget.project!);
    }
  }

  @override
  void dispose() {
    Get.delete<ProjectFormController>();
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
      if (await isValid) {
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

              return ProjectForm(
                controller: controller,
                config: FormConfig(
                  title: widget.project != null
                      ? 'Editar Proyecto'
                      : 'Nuevo Proyecto',
                  primaryButtonText: 'Guardar',
                  secondaryButtonText: 'Cancelar',
                  showObservations: !widget.isEditing,
                  showFiles: !widget.isEditing,
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
