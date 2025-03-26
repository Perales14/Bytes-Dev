import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/client_form_controller.dart';
import '../../../shared/models/form_config.dart';
import 'client_form.dart';

import '../../../data/services/client_service.dart';
import '../../../data/services/observation_service.dart';

class AddClientsDialog extends StatefulWidget {
  final Function onSaveSuccess;

  const AddClientsDialog({
    required this.onSaveSuccess,
    super.key,
  });

  @override
  State<AddClientsDialog> createState() => _AddClientsDialogState();
}

class _AddClientsDialogState extends State<AddClientsDialog> {
  late final ClientFormController controller;

  @override
  void initState() {
    super.initState();
    // Verificamos y registramos servicios si es necesario
    if (!Get.isRegistered<ObservationService>()) {
      Get.lazyPut(() => ObservationService());
    }

    if (!Get.isRegistered<ClientService>()) {
      Get.lazyPut(() => ClientService());
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
