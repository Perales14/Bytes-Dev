import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/models/form_config.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/role_service.dart';
import '../../../data/services/file_service.dart';
import '../controllers/project_form_controller.dart';
import '../../../data/models/user_model.dart';
import 'project_form.dart';

class AddProjectDialog extends StatefulWidget {
  final Function onSaveSuccess;
  final UserModel? employee;
  final bool isEditing;

  const AddProjectDialog({
    required this.onSaveSuccess,
    this.employee,
    this.isEditing = false,
    super.key,
  });

  @override
  State<AddProjectDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddProjectDialog> {
  late final ProjectFormController controller;

  @override
  void initState() {
    super.initState();

    // Verificamos y registramos servicios si es necesario
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut(() => UserService());
    }

    if (!Get.isRegistered<RoleService>()) {
      Get.lazyPut(() => RoleService());
    }

    if (!Get.isRegistered<FileService>()) {
      Get.lazyPut(() => FileService());
    }

    // Inicializamos el controlador
    controller = Get.put(ProjectFormController());

    // Si estamos en modo edición, cargamos los datos del empleado
    if (widget.employee != null) {
      controller.loadUser(widget.employee!);
    }
  }

  @override
  void dispose() {
    // Asegurarse de eliminar el controlador al cerrar el diálogo
    Get.delete<ProjectFormController>();
    super.dispose();
  }

  // Función que se ejecuta cuando el usuario cancela
  void _handleCancel() {
    // Verificamos que el widget esté montado y podamos cerrar el diálogo
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  // Función que se ejecuta cuando se intenta guardar el formulario
  void _handleSubmit() async {
    try {
      final isValid = controller.submitForm();

      if (isValid) {
        // Ya no es necesario mostrar este snackbar aquí, ya que
        // el controlador ya muestra un mensaje de éxito

        // Cierra el diálogo y notifica al padre para refrescar datos
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
          widget.onSaveSuccess();
        }
      }
    } catch (e) {
      // Si ocurre un error no manejado, mostramos un mensaje
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

              return EmployeeForm(
                controller: controller,
                config: FormConfig(
                  title: widget.employee != null
                      ? 'Editar Empleado'
                      : 'Nuevo Empleado',
                  primaryButtonText: 'Guardar',
                  secondaryButtonText: 'Cancelar',
                  // No mostrar observaciones ni archivos en modo edición
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
