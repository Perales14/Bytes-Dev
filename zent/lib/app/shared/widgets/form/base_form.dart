import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zent/app/shared/controllers/base_form_controller.dart';
import 'package:zent/app/shared/models/form_config.dart';
import 'package:zent/app/shared/widgets/form/widgets/button_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/widgets/form/widgets/observations_field.dart';

/// Clase base abstracta para formularios de la aplicación.
///
/// Proporciona una estructura común para todos los formularios,
/// incluyendo decoración, título, botones de acción y secciones estándar.
abstract class BaseForm extends StatelessWidget {
  /// Controlador para manejar la lógica del formulario
  final BaseFormController controller;

  /// Configuración del formulario (título, textos de botones)
  final FormConfig config;

  /// Función a ejecutar cuando se cancela el formulario
  final Function onCancel;

  /// Función a ejecutar cuando se envía el formulario correctamente
  final Function onSubmit;

  /// Constructor para el formulario base
  const BaseForm({
    required this.controller,
    required this.config,
    required this.onCancel,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: buildContainerDecoration(theme),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Importante: evita error de constraints
            children: [
              // Título del formulario
              buildFormTitle(theme),
              const SizedBox(height: 20),

              // Contenido específico del formulario
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.5, // Altura sugerida
                child: buildFormContent(context),
              ),

              const SizedBox(height: 20),

              // Botones de acción
              buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la decoración del contenedor principal del formulario
  BoxDecoration buildContainerDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: theme.colorScheme.onSurface.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Construye el título del formulario centrado en la parte superior
  Widget buildFormTitle(ThemeData theme) {
    return Center(
      child: Text(
        config.title,
        style: theme.textTheme.displayLarge,
      ),
    );
  }

  /// Construye el título de una sección del formulario
  ///
  /// [theme] Tema actual de la aplicación
  /// [title] Texto del título de la sección
  Widget buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.secondary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Construye la sección de observaciones del formulario
  ///
  /// [theme] Tema actual de la aplicación
  /// [observations] Texto inicial de las observaciones
  /// [onChanged] Callback que se ejecuta cuando cambia el texto
  Widget buildObservationsSection(
      ThemeData theme, String observations, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 20),
        SizedBox(
          height: 230,
          child: ObservationsField(
            initialValue: observations,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  /// Construye los botones de acción del formulario (cancelar y guardar)
  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonForm(
          texto: config.secondaryButtonText,
          onPressed: () => onCancel(),
          isPrimary: false,
        ),
        const SizedBox(width: 100),
        ButtonForm(
          texto: config.primaryButtonText,
          onPressed: () {
            // Validar el formulario antes de llamar al callback
            if (controller.formKey.currentState?.validate() ?? false) {
              if (kDebugMode) {
                print('Formulario válido');
              }
              onSubmit();
            } else {
              if (kDebugMode) {
                print('Formulario inválido');
              }
            }
          },
          icon: Icons.add,
        ),
      ],
    );
  }

  /// Método abstracto que deben implementar las subclases
  /// para proporcionar el contenido específico del formulario
  Widget buildFormContent(BuildContext context);
}
