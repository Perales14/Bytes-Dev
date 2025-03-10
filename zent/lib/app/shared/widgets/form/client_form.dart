import 'package:flutter/material.dart';
import 'package:zent/app/shared/controllers/client_form_controller.dart';
import 'package:zent/app/shared/models/form_config.dart';
import 'package:zent/app/shared/widgets/form/base_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/text_field_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/dropdown_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/label_display.dart';

class ClientForm extends BaseForm {
  // Constructor sin redeclaraciones problemáticas
  const ClientForm({
    required ClientFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  // Acceso tipado al controller
  ClientFormController get clientController =>
      controller as ClientFormController;

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación importante
      mainAxisSize: MainAxisSize.min, // Evita expandirse infinitamente
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
              clientController.model.observaciones,
              (value) => clientController.updateClient(observaciones: value),
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
                value: clientController.model.id ?? 'Auto-generado',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabelDisplay(
                label: 'Fecha de Registro',
                value: clientController.model.fechaRegistro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownForm(
                label: 'Tipo de Cliente',
                opciones: clientController.tiposCliente,
                value: clientController.model.tipoCliente,
                onChanged: (value) =>
                    clientController.updateClient(tipoCliente: value),
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
                    TextEditingController(text: clientController.model.nombre),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: clientController.model.apellidoPaterno),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(apellidoPaterno: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: clientController.model.apellidoMaterno),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(apellidoMaterno: value),
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
                    TextEditingController(text: clientController.model.correo),
                validator: clientController.validateEmail,
                onChanged: (value) =>
                    clientController.updateClient(correo: value),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller: TextEditingController(
                    text: clientController.model.telefono),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(telefono: value),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'RFC',
                controller:
                    TextEditingController(text: clientController.model.rfc),
                validator: clientController.validateRFC,
                onChanged: (value) => clientController.updateClient(rfc: value),
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
                controller: TextEditingController(
                    text: clientController.model.nombreEmpresa),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(nombreEmpresa: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Cargo',
                controller:
                    TextEditingController(text: clientController.model.cargo),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(cargo: value),
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
                    TextEditingController(text: clientController.model.calle),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(calle: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Colonia',
                controller:
                    TextEditingController(text: clientController.model.colonia),
                validator: clientController.validateRequired,
                onChanged: (value) =>
                    clientController.updateClient(colonia: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'CP',
                controller:
                    TextEditingController(text: clientController.model.cp),
                validator: clientController.validateCP,
                onChanged: (value) => clientController.updateClient(cp: value),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
