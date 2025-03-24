import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/repositories/cliente_repository.dart';
import '../../../data/repositories/observacion_repository.dart';
import '../../../shared/models/form_config.dart';
import '../../clients/controllers/client_form_controller.dart';
import '../../clients/widgets/client_form.dart';

class AddProvidersDialog extends StatefulWidget {
  final Function onSaveSuccess;

  const AddProvidersDialog({
    required this.onSaveSuccess,
    super.key,
  });

  @override
  State<AddProvidersDialog> createState() => _AddProvidersDialogState();
}

class _AddProvidersDialogState extends State<AddProvidersDialog> {
  late final ClientFormController controller;

  @override
  void initState() {
    super.initState();
    // Utilizamos lazyPut para permitir la inyección de dependencias
    if (!Get.isRegistered<ObservacionRepository>()) {
      Get.lazyPut(() => ObservacionRepository());
    }

    if (!Get.isRegistered<ClienteRepository>()) {
      Get.lazyPut(() => ClienteRepository());
    }

    // Inicializamos el controlador
    controller = Get.put(ClientFormController());
  }

  @override
  void dispose() {
    // Asegurarse de eliminar el controlador al cerrar el diálogo
    Get.delete<ClientFormController>();
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
  void _handleSubmit() {
    bool isValid = controller.submitForm();

    if (isValid) {
      // El mensaje de éxito ya se muestra en el controlador
      // Cierra el diálogo y notifica al padre para refrescar datos
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
        widget.onSaveSuccess();
      }
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
            child: ClientForm(
              controller: controller,
              config: FormConfig.client,
              onCancel: _handleCancel,
              onSubmit: _handleSubmit,
            ),
          ),
        ),
      ),
    );
  }
}
