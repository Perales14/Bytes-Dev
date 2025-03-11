import 'package:flutter/material.dart';
import 'package:zent/app/shared/controllers/base_form_controller.dart';
import 'package:zent/app/shared/models/form_config.dart';
import 'package:zent/app/shared/widgets/form/widgets/button_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/observations_field.dart';

abstract class BaseForm extends StatelessWidget {
  final BaseFormController controller;
  final FormConfig config;
  final Function onCancel;
  final Function onSubmit;

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

  Widget buildFormTitle(ThemeData theme) {
    return Center(
      child: Text(
        config.title,
        style: theme.textTheme.displayLarge,
      ),
    );
  }

  Widget buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.secondary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

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

  // Implementación de los botones de acción con los callbacks correctos
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
              print('Formulario válido');
              onSubmit();
            } else {
              print('Formulario inválido');
            }
          },
          icon: Icons.add,
        ),
      ],
    );
  }

  // Método abstracto que deben implementar las subclases
  Widget buildFormContent(BuildContext context);
}
