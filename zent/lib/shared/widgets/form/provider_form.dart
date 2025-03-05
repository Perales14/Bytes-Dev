import 'package:flutter/material.dart';
import 'package:zent/controllers/provider_form_controller.dart';
import 'package:zent/models/form_config.dart';
import 'package:zent/shared/widgets/form/base_form.dart';
import 'package:zent/shared/widgets/form/widgets/text_field_form.dart';
import 'package:zent/shared/widgets/form/widgets/dropdown_form.dart';
import 'package:zent/shared/widgets/form/widgets/label_display.dart';

class ProviderForm extends BaseForm {
  @override
  final ProviderFormController controller;

  const ProviderForm({
    required this.controller,
    required super.config,
    super.key,
  }) : super(controller: controller);

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Datos de contacto y Observaciones
        _buildContactDataAndObservations(theme),
        const SizedBox(height: 30),

        // Datos de la empresa
        _buildCompanyData(theme),
      ],
    );
  }

  Widget _buildContactDataAndObservations(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos de contacto
        Expanded(
          flex: 2,
          child: _buildContactDataSection(theme),
        ),
        const SizedBox(width: 20),

        // Observaciones
        if (config.showObservations)
          Expanded(
            flex: config.observationsFlex,
            child: buildObservationsSection(
              theme,
              controller.provider.observaciones,
              (value) => controller.updateProvider(observaciones: value),
            ),
          ),
      ],
    );
  }

  Widget _buildContactDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Datos de Contacto'),
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

  Widget _buildCompanyData(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Datos de la Empresa'),
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
}
