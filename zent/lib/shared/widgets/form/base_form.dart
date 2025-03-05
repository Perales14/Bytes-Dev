import 'package:flutter/material.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/models/form_config.dart';
import 'package:zent/shared/widgets/form/widgets/button_form.dart';
import 'package:zent/shared/widgets/form/widgets/observations_field.dart';

abstract class BaseForm extends StatelessWidget {
  final BaseFormController controller;
  final FormConfig config;

  const BaseForm({
    required this.controller,
    required this.config,
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
            children: [
              buildFormTitle(theme),
              const SizedBox(height: 30),
              buildFormContent(context),
              const SizedBox(height: 30),
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

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonForm(
          texto: config.secondaryButtonText,
          onPressed: () => controller.resetForm(),
          isPrimary: false,
        ),
        const SizedBox(width: 100),
        ButtonForm(
          texto: config.primaryButtonText,
          onPressed: () => controller.submitForm(),
          icon: Icons.add,
        ),
      ],
    );
  }

  // Método abstracto que deben implementar las subclases
  Widget buildFormContent(BuildContext context);
}
