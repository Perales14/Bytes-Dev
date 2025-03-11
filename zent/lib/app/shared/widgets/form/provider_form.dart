import 'package:flutter/material.dart';
import 'package:zent/app/shared/controllers/provider_form_controller.dart';
import 'package:zent/app/shared/models/form_config.dart';
import 'package:zent/app/shared/widgets/form/base_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/text_field_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/dropdown_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/label_display.dart';

class ProviderForm extends BaseForm {
  // Constructor sin redeclaraciones problemáticas
  const ProviderForm({
    required ProviderFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  // Acceso tipado al controller
  ProviderFormController get providerController =>
      controller as ProviderFormController;

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación importante
      mainAxisSize: MainAxisSize.min, // Evita expandirse infinitamente
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
              providerController.provider.observaciones,
              (value) =>
                  providerController.updateProvider(observaciones: value),
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
                value: providerController.provider.id ?? 'Auto-generado',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabelDisplay(
                label: 'Fecha de Registro',
                value: providerController.provider.fechaRegistro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownForm(
                label: 'Tipo de Servicio',
                opciones: providerController.tiposServicio,
                value: providerController.provider.tipoServicio,
                onChanged: (value) =>
                    providerController.updateProvider(tipoServicio: value),
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
                controller: TextEditingController(
                    text: providerController.provider.nombre),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: providerController.provider.apellidoPaterno),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(apellidoPaterno: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: providerController.provider.apellidoMaterno),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(apellidoMaterno: value),
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
                controller: TextEditingController(
                    text: providerController.provider.correo),
                validator: providerController.validateEmail,
                onChanged: (value) =>
                    providerController.updateProvider(correo: value),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller: TextEditingController(
                    text: providerController.provider.telefono),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(telefono: value),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'RFC',
                controller: TextEditingController(
                    text: providerController.provider.rfc),
                validator: providerController.validateRFC,
                onChanged: (value) =>
                    providerController.updateProvider(rfc: value),
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
                    text: providerController.provider.nombreEmpresa),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(nombreEmpresa: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Cargo',
                controller: TextEditingController(
                    text: providerController.provider.cargo),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(cargo: value),
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
                controller: TextEditingController(
                    text: providerController.provider.calle),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(calle: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Colonia',
                controller: TextEditingController(
                    text: providerController.provider.colonia),
                validator: providerController.validateRequired,
                onChanged: (value) =>
                    providerController.updateProvider(colonia: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Código Postal',
                controller:
                    TextEditingController(text: providerController.provider.cp),
                validator: providerController.validateCP,
                onChanged: (value) =>
                    providerController.updateProvider(cp: value),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
