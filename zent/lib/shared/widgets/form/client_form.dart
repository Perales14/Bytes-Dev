import 'package:flutter/material.dart';
import 'package:zent/controllers/client_form_controller.dart';
import 'package:zent/models/form_config.dart';
import 'package:zent/shared/widgets/form/base_form.dart';
import 'package:zent/shared/widgets/form/widgets/text_field_form.dart';
import 'package:zent/shared/widgets/form/widgets/dropdown_form.dart';
import 'package:zent/shared/widgets/form/widgets/label_display.dart';

class ClientForm extends BaseForm {
  @override
  final ClientFormController controller;

  const ClientForm({
    required this.controller,
    required super.config,
    super.key,
  }) : super(controller: controller);

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Datos del cliente y Observaciones
        _buildClientDataAndObservations(theme),
        const SizedBox(height: 30),

        // Datos de la empresa
        _buildCompanyData(theme),
      ],
    );
  }

  Widget _buildClientDataAndObservations(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos del cliente
        Expanded(
          flex: 2,
          child: _buildClientDataSection(theme),
        ),
        const SizedBox(width: 20),

        // Observaciones
        if (config.showObservations)
          Expanded(
            flex: config.observationsFlex,
            child: buildObservationsSection(
              theme,
              controller.model.observaciones,
              (value) => controller.updateClient(observaciones: value),
            ),
          ),
      ],
    );
  }

  Widget _buildClientDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Datos del Cliente'),
        const SizedBox(height: 20),

        // ID, Fecha de Registro, Tipo de Cliente
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
                onChanged: (value) =>
                    controller.updateClient(tipoCliente: value),
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

        // Correo, Teléfono, RFC
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

        // Calle, Colonia, CP
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
}
