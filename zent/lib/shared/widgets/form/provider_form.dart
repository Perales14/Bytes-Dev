import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/provider_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';
import 'package:zent/shared/widgets/form/label_display.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';

class ProviderForm extends StatelessWidget {
  final ProviderFormController controller;
  final FormConfig config;

  const ProviderForm({
    required this.controller,
    required this.config,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: _buildContainerDecoration(theme),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormTitle(theme),
              const SizedBox(height: 30),

              // Datos personales y observaciones
              _buildPersonalDataAndObservations(),
              const SizedBox(height: 30),

              // Datos de la empresa
              _buildCompanyData(theme),
              const SizedBox(height: 30),

              // Botones de acción
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration(ThemeData theme) {
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

  Widget _buildFormTitle(ThemeData theme) {
    return Center(
      child: Text(
        config.title,
        style: theme.textTheme.displayLarge,
      ),
    );
  }

  Widget _buildPersonalDataAndObservations() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos personales
        Expanded(
          flex: 2,
          child: _buildPersonalDataSection(),
        ),
        const SizedBox(width: 20),

        // Observaciones
        if (config.showObservations)
          Expanded(
            flex: config.observationsFlex,
            child: _buildObservationsSection(),
          ),
      ],
    );
  }

  Widget _buildPersonalDataSection() {
    final theme = Theme.of(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos de Contacto',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // ID, Fecha de Registro, Tipo de Servicio
        Row(
          children: [
            Expanded(
              child: LabelDisplay(
                label: 'ID',
                value: controller.provider.id ?? 'Auto-generado',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabelDisplay(
                label: 'Fecha de Registro',
                value: controller.provider.fechaRegistro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownForm(
                label: 'Tipo de Servicio',
                opciones: controller.tiposServicio,
                value: controller.provider.tipoServicio,
                onChanged: (value) =>
                    controller.updateProvider(tipoServicio: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Nombre, Apellido Paterno, Apellido Materno
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre',
                controller:
                    TextEditingController(text: controller.provider.nombre),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateProvider(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: controller.provider.apellidoPaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateProvider(apellidoPaterno: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: controller.provider.apellidoMaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateProvider(apellidoMaterno: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Correo, Teléfono, RFC
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Correo Electrónico',
                controller:
                    TextEditingController(text: controller.provider.correo),
                validator: controller.validateEmail,
                onChanged: (value) => controller.updateProvider(correo: value),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller:
                    TextEditingController(text: controller.provider.telefono),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateProvider(telefono: value),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'RFC',
                controller:
                    TextEditingController(text: controller.provider.rfc),
                validator: controller.validateRFC,
                onChanged: (value) => controller.updateProvider(rfc: value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildObservationsSection() {
    final theme = Theme.of(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observaciones',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 230, // Altura equivalente a aprox. tres filas de campos
          child: ObservationsField(
            initialValue: controller.provider.observaciones,
            onChanged: (value) =>
                controller.updateProvider(observaciones: value),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyData(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos de la Empresa',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Nombre Empresa, Cargo
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre de la Empresa',
                controller: TextEditingController(
                    text: controller.provider.nombreEmpresa),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateProvider(nombreEmpresa: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Cargo',
                controller:
                    TextEditingController(text: controller.provider.cargo),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateProvider(cargo: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Calle, Colonia, CP
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Calle y Número',
                controller:
                    TextEditingController(text: controller.provider.calle),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateProvider(calle: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Colonia',
                controller:
                    TextEditingController(text: controller.provider.colonia),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateProvider(colonia: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Código Postal',
                controller: TextEditingController(text: controller.provider.cp),
                validator: controller.validateCP,
                onChanged: (value) => controller.updateProvider(cp: value),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
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
}
