import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/provider_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';
import 'package:zent/shared/widgets/form/reactive_form_field.dart';
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
                    label: 'Tipo de Servicio',
                    opciones: controller.tiposServicio,
                    value: controller.tipoServicio.value,
                    onChanged: (value) => controller.tipoServicio.value = value,
                  )),
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

        // Correo, Teléfono, RFC
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

        // Nombre Empresa, Cargo
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre de la Empresa',
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

        // Calle, Colonia, CP
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
                label: 'Código Postal',
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
