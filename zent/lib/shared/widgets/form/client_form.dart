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
                value: controller.model.id ?? 'Auto-generado',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabelDisplay(
                label: 'Fecha de Registro',
                value: controller.model.fechaRegistro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownForm(
                label: 'Tipo de Cliente',
                opciones: controller.tiposCliente,
                value: controller.model.tipoCliente,
                onChanged: (value) {
                  controller.updateClient(tipoCliente: value);
                },
              ),
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
                    TextEditingController(text: controller.model.nombre),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateClient(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: controller.model.apellidoPaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateClient(apellidoPaterno: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: controller.model.apellidoMaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateClient(apellidoMaterno: value),
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
                    TextEditingController(text: controller.model.correo),
                validator: controller.validateEmail,
                onChanged: (value) => controller.updateClient(correo: value),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller:
                    TextEditingController(text: controller.model.telefono),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateClient(telefono: value),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'RFC',
                controller: TextEditingController(text: controller.model.rfc),
                validator: controller.validateRFC,
                onChanged: (value) => controller.updateClient(rfc: value),
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
          child: ObservationsField(
            initialValue: controller.model.observaciones,
            onChanged: (value) => controller.updateClient(observaciones: value),
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
                    TextEditingController(text: controller.model.nombreEmpresa),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateClient(nombreEmpresa: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Cargo',
                controller: TextEditingController(text: controller.model.cargo),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateClient(cargo: value),
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
                controller: TextEditingController(text: controller.model.calle),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateClient(calle: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Colonia',
                controller:
                    TextEditingController(text: controller.model.colonia),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateClient(colonia: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'CP',
                controller: TextEditingController(text: controller.model.cp),
                validator: controller.validateCP,
                onChanged: (value) => controller.updateClient(cp: value),
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
