import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/client_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/reactive_form_field.dart';
import 'package:zent/shared/widgets/form/label_display.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';

class ClientForm extends StatelessWidget {
  final ClientFormController controller;
  final FormConfig config;

  const ClientForm({
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
              _buildClientDataAndObservations(theme),
              const SizedBox(height: 30),
              _buildCompanyData(theme),
              const SizedBox(height: 30),
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

  Widget _buildClientDataAndObservations(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Client data
        Expanded(
          flex: 2,
          child: _buildClientDataSection(theme),
        ),
        const SizedBox(width: 20),

        // Observations
        if (config.showObservations)
          Expanded(
            flex: config.observationsFlex,
            child: _buildObservationsSection(theme),
          ),
      ],
    );
  }

  Widget _buildClientDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos del Cliente',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Row 1: ID, Registration Date, Client Type
        Row(
          children: [
            Expanded(
              child: LabelDisplay(
                label: 'ID',
                value: controller.id.value.isEmpty
                    ? 'Auto-generado'
                    : controller.id.value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabelDisplay(
                label: 'Fecha de Registro',
                value: controller.fechaRegistro.value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() => DropdownForm(
                    label: 'Tipo de Cliente',
                    opciones: controller.tiposCliente,
                    value: controller.tipoCliente.value,
                    onChanged: (value) => controller.tipoCliente.value = value,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Row 2: Name, Last Names
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre',
                controller:
                    TextEditingController(text: controller.nombre.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.nombre.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: controller.apellidoPaterno.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.apellidoPaterno.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: controller.apellidoMaterno.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.apellidoMaterno.value = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Row 3: Email, Phone, RFC
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Correo Electrónico',
                controller:
                    TextEditingController(text: controller.correo.value),
                validator: controller.validateEmail,
                onChanged: (value) => controller.correo.value = value,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller:
                    TextEditingController(text: controller.telefono.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.telefono.value = value,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'RFC',
                controller: TextEditingController(text: controller.rfc.value),
                validator: controller.validateRFC,
                onChanged: (value) => controller.rfc.value = value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildObservationsSection(ThemeData theme) {
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
          height: 230,
          child: ReactiveFormField<String>(
            value: controller.observaciones,
            builder: (observaciones) => ObservationsField(
              initialValue: observaciones,
              onChanged: (value) => controller.observaciones.value = value,
            ),
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

        // Row 1: Company Name, Position
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre de la empresa',
                controller:
                    TextEditingController(text: controller.nombreEmpresa.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.nombreEmpresa.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Cargo',
                controller: TextEditingController(text: controller.cargo.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.cargo.value = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Row 2: Street, Neighborhood, Postal Code
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Calle y Número',
                controller: TextEditingController(text: controller.calle.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.calle.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Colonia',
                controller:
                    TextEditingController(text: controller.colonia.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.colonia.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'CP',
                controller: TextEditingController(text: controller.cp.value),
                validator: controller.validateCP,
                onChanged: (value) => controller.cp.value = value,
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
