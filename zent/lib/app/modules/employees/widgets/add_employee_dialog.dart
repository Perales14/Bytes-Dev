import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shared/models/form_config.dart';
import '../../../data/repositories/usuario_repository.dart';
import '../controllers/employee_form_controller.dart';
import 'employee_form.dart';

class AddEmployeeDialog extends StatefulWidget {
  final Function onSaveSuccess;

  const AddEmployeeDialog({
    required this.onSaveSuccess,
    super.key,
  });

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  late final EmployeeFormController controller;

  @override
  void initState() {
    super.initState();
    // Asegurar que el repositorio esté registrado
    if (!Get.isRegistered<UsuarioRepository>()) {
      Get.lazyPut<UsuarioRepository>(() => UsuarioRepository());
    }

    // Inicializamos el controlador utilizando GetX para gestión de dependencias
    controller = Get.put(EmployeeFormController());
  }

  @override
  void dispose() {
    // Asegurarse de eliminar el controlador al cerrar el diálogo
    Get.delete<EmployeeFormController>();
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
      // Escuchamos eventos de teclado para cerrar con Escape
      focusNode: FocusNode()..requestFocus(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape &&
            mounted &&
            Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      // Añadimos un efecto de desenfoque al fondo
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          // Eliminamos el padding interno del Dialog por defecto
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
            child: EmployeeForm(
              controller: controller,
              config: FormConfig.employee,
              // Pasamos correctamente las funciones de cancelar y enviar
              onCancel: _handleCancel,
              onSubmit: _handleSubmit,
            ),
          ),
        ),
      ),
    );
  }
}
