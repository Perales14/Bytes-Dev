import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/client_form_controller.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../shared/widgets/form/widgets/observations_field.dart';
import '../../../shared/widgets/form/widgets/text_field_form.dart';
import '../../../shared/widgets/form/widgets/dropdown_form.dart';

/// Formulario para la creación y edición de clientes
class ClientForm extends BaseForm {
  /// Constructor con tipado seguro para el controlador
  const ClientForm({
    required ClientFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  /// Acceso tipado al controlador para evitar casteos repetitivos
  ClientFormController get clientController =>
      controller as ClientFormController;

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildClientDataSection(theme),
            const SizedBox(height: 20),
            if (config.showObservations) _buildObservationsSection(theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Sección de datos básicos del cliente (personales y de contacto)
  Widget _buildClientDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Datos del Cliente'),
        const SizedBox(height: 20),
        _buildClientTypeRow(),
        const SizedBox(height: 10),
        _buildPersonalInfoRow(),
        const SizedBox(height: 10),
        _buildContactInfoRow(),
      ],
    );
  }

  /// Selector de tipo de cliente
  Widget _buildClientTypeRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownForm(
            label: 'Tipo de Cliente',
            opciones: clientController.clientTypes,
            value: clientController.client.clientType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe seleccionar un tipo de cliente';
              }
              return null;
            },
            onChanged: (value) {
              if (value != null && value.isNotEmpty) {
                clientController.updateClient(clientType: value);
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container()),
        const SizedBox(width: 10),
        Expanded(child: Container()),
      ],
    );
  }

  /// Campos para nombre y apellidos
  Widget _buildPersonalInfoRow() {
    return Row(
      children: [
        Expanded(
          child: TextFieldForm(
            label: 'Nombre',
            controller:
                TextEditingController(text: clientController.client.name),
            validator: clientController.validateRequired,
            onChanged: (value) => clientController.updateClient(name: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'Apellido Paterno',
            controller: TextEditingController(
                text: clientController.client.fatherLastName),
            validator: clientController.validateRequired,
            onChanged: (value) =>
                clientController.updateClient(fatherLastName: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'Apellido Materno',
            controller: TextEditingController(
                text: clientController.client.motherLastName ?? ''),
            onChanged: (value) =>
                clientController.updateClient(motherLastName: value),
          ),
        ),
      ],
    );
  }

  /// Campos para información de contacto y fiscal
  Widget _buildContactInfoRow() {
    return Row(
      children: [
        Expanded(
          child: TextFieldForm(
            label: 'Correo Electrónico',
            controller: TextEditingController(
                text: clientController.client.email ?? ''),
            validator: clientController.validateEmail,
            onChanged: (value) => clientController.updateClient(email: value),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'Teléfono',
            controller: TextEditingController(
                text: clientController.client.phoneNumber ?? ''),
            validator: clientController.validateRequired,
            onChanged: (value) =>
                clientController.updateClient(phoneNumber: value),
            keyboardType: TextInputType.phone,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'RFC',
            controller: TextEditingController(
                text: clientController.client.taxIdentificationNumber ?? ''),
            validator: clientController.validateTaxId,
            onChanged: (value) =>
                clientController.updateClient(taxIdentificationNumber: value),
          ),
        ),
      ],
    );
  }

  /// Sección de observaciones del cliente
  Widget _buildObservationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: Obx(() => ObservationsField(
                initialValue: clientController.observationText.value,
                onChanged: (value) => clientController.updateObservation(value),
              )),
        ),
      ],
    );
  }
}
