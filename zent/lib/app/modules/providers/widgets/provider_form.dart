import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/provider_form_controller.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../shared/widgets/form/widgets/text_field_form.dart';
import '../../../shared/widgets/form/widgets/dropdown_form.dart';
import '../../../shared/widgets/form/widgets/observations_field.dart';
import '../../../shared/widgets/form/widgets/button_form.dart';

class ProviderForm extends BaseForm {
  final String submitText;

  const ProviderForm({
    required ProviderFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    required this.submitText,
    super.key,
  });

  ProviderFormController get providerController =>
      controller as ProviderFormController;

  @override
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
          texto: submitText,
          onPressed: () {
            if (controller.formKey.currentState?.validate() ?? false) {
              onSubmit();
            }
          },
          icon: Icons.save,
        ),
      ],
    );
  }

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
            _buildProviderDataSection(theme),
            const SizedBox(height: 20),
            if (config.showObservations) _buildObservationsSection(theme),
            const SizedBox(height: 20),
            _buildContactSection(theme),
            const SizedBox(height: 20),
            _buildAddressToggleSection(theme),
            Obx(() => providerController.showAddress.value
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildAddressSection(theme),
                    ],
                  )
                : Container()),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderDataSection(ThemeData theme) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle(theme, 'Datos del Proveedor'),
            const SizedBox(height: 20),
            _buildSpecialtyAndCompanyRow(),
            const SizedBox(height: 10),
            _buildServiceAndPaymentRow(),
          ],
        ));
  }

  Widget _buildSpecialtyAndCompanyRow() {
    return Row(
      children: [
        Expanded(child: _buildSpecialtyDropdown()),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: TextFieldForm(
            label: 'Nombre de la Empresa',
            controller: providerController.companyNameController,
            validator: providerController.validateRequired,
            onChanged: (value) =>
                providerController.updateProvider(companyName: value),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyDropdown() {
    return Obx(() {
      if (providerController.specialties.isEmpty) {
        return TextFieldForm(
          label: 'Especialidad',
          controller: TextEditingController(text: 'Cargando...'),
        );
      }

      final currentSpecialty = providerController.getCurrentSpecialty();
      final defaultValue = providerController.specialties.isNotEmpty
          ? providerController.specialties.first.name
          : 'Cargando...';

      return DropdownForm(
        label: 'Especialidad',
        opciones:
            providerController.specialties.map((esp) => esp.name).toList(),
        value: currentSpecialty?.name ?? defaultValue,
        onChanged: (value) => _onSpecialtyChanged(value!),
        validator: providerController.validateRequired,
      );
    });
  }

  void _onSpecialtyChanged(String value) {
    try {
      final specialty = providerController.specialties.firstWhere(
        (esp) => esp.name == value,
        orElse: () => providerController.specialties.first,
      );
      providerController.updateProvider(specialtyId: specialty.id);
    } catch (_) {
      // Manejo silencioso de errores
    }
  }

  Widget _buildServiceAndPaymentRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownForm(
            label: 'Tipo de Servicio',
            opciones: providerController.serviceTypes,
            value: providerController.provider.value.serviceType,
            validator: providerController.validateServiceType,
            onChanged: (value) =>
                providerController.updateProvider(serviceType: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownForm(
            label: 'Condiciones de Pago',
            opciones: providerController.paymentTerms,
            value: providerController.provider.value.paymentTerms,
            validator: providerController.validatePaymentTerms,
            onChanged: (value) =>
                providerController.updateProvider(paymentTerms: value),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Información de Contacto'),
        const SizedBox(height: 20),
        TextFieldForm(
          label: 'Contacto Principal',
          controller: providerController.mainContactController,
          onChanged: (value) =>
              providerController.updateProvider(mainContactName: value),
        ),
        const SizedBox(height: 10),
        _buildContactFieldsRow(),
      ],
    );
  }

  Widget _buildContactFieldsRow() {
    return Row(
      children: [
        Expanded(
          child: TextFieldForm(
            label: 'Teléfono',
            controller: providerController.phoneController,
            onChanged: (value) =>
                providerController.updateProvider(phoneNumber: value),
            keyboardType: TextInputType.phone,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'Email',
            controller: providerController.emailController,
            validator: providerController.validateEmail,
            onChanged: (value) =>
                providerController.updateProvider(email: value),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'RFC',
            controller: providerController.taxIdController,
            validator: providerController.validateTaxId,
            onChanged: (value) =>
                providerController.updateProvider(taxId: value),
          ),
        ),
      ],
    );
  }

  Widget _buildObservationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: Obx(() => ObservationsField(
                initialValue: providerController.observationText.value,
                onChanged: (value) =>
                    providerController.updateObservation(value),
              )),
        ),
      ],
    );
  }

  Widget _buildAddressToggleSection(ThemeData theme) {
    return Obx(() => CheckboxListTile(
          title: Text('Agregar dirección', style: theme.textTheme.titleMedium),
          value: providerController.showAddress.value,
          onChanged: (value) {
            if (value != null) {
              providerController.showAddress.value = value;
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
        ));
  }

  Widget _buildAddressSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Dirección'),
        const SizedBox(height: 20),
        _buildAddressStreetRow(),
        const SizedBox(height: 10),
        _buildAddressNeighborhoodRow(),
        const SizedBox(height: 10),
        _buildAddressStateRow(),
      ],
    );
  }

  Widget _buildAddressStreetRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFieldForm(
            label: 'Calle',
            controller: providerController.streetController,
            validator: (value) => providerController.showAddress.value
                ? providerController.validateRequired(value)
                : null,
            onChanged: (value) =>
                providerController.updateAddress(street: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFieldForm(
            label: 'Número',
            controller: providerController.streetNumberController,
            validator: (value) => providerController.showAddress.value
                ? providerController.validateRequired(value)
                : null,
            onChanged: (value) =>
                providerController.updateAddress(streetNumber: value),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressNeighborhoodRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFieldForm(
            label: 'Colonia',
            controller: providerController.neighborhoodController,
            validator: (value) => providerController.showAddress.value
                ? providerController.validateRequired(value)
                : null,
            onChanged: (value) =>
                providerController.updateAddress(neighborhood: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFieldForm(
            label: 'Código Postal',
            controller: providerController.postalCodeController,
            validator: providerController.validatePostalCode,
            onChanged: (value) =>
                providerController.updateAddress(postalCode: value),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressStateRow() {
    return Row(
      children: [
        Expanded(
          child: TextFieldForm(
            label: 'Estado',
            controller: providerController.stateController,
            onChanged: (value) =>
                providerController.updateAddress(state: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'País',
            controller: providerController.countryController,
            onChanged: (value) =>
                providerController.updateAddress(country: value),
          ),
        ),
      ],
    );
  }
}
