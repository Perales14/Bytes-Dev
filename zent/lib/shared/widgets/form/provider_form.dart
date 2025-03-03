import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/provider_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/label_display.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';
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
      decoration: BoxDecoration(
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
      ),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  config.title,
                  style: theme.textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 30),

              // Main content row
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Provider Data
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Datos del Proveedor',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Row 1: Company name and role
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Nombre de la empresa',
                                  controller: TextEditingController(
                                      text: controller.nombreEmpresa.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.nombreEmpresa.value = value,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Cargo',
                                  controller: TextEditingController(
                                      text: controller.cargo.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.cargo.value = value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Row 2: Address
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Calle y Número',
                                  controller: TextEditingController(
                                      text: controller.calle.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.calle.value = value,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Colonia',
                                  controller: TextEditingController(
                                      text: controller.colonia.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.colonia.value = value,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFieldForm(
                                  label: 'CP',
                                  controller: TextEditingController(
                                      text: controller.cp.value),
                                  validator: controller.validateCP,
                                  onChanged: (value) =>
                                      controller.cp.value = value,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Row 3: Name
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Nombre',
                                  controller: TextEditingController(
                                      text: controller.nombre.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.nombre.value = value,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Apellido Paterno',
                                  controller: TextEditingController(
                                      text: controller.apellidoPaterno.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.apellidoPaterno.value = value,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Apellido Materno',
                                  controller: TextEditingController(
                                      text: controller.apellidoMaterno.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.apellidoMaterno.value = value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Row 4: Contact info (completing)
                          Row(
                            children: [
                              // Correo Electrónico (already implemented)
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Correo Electrónico',
                                  controller: TextEditingController(
                                      text: controller.correo.value),
                                  validator: controller.validateEmail,
                                  onChanged: (value) =>
                                      controller.correo.value = value,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Teléfono (completing)
                              Expanded(
                                child: TextFieldForm(
                                  label: 'Teléfono',
                                  controller: TextEditingController(
                                      text: controller.telefono.value),
                                  validator: controller.validateRequired,
                                  onChanged: (value) =>
                                      controller.telefono.value = value,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // RFC
                              Expanded(
                                child: TextFieldForm(
                                    label: 'RFC',
                                    controller: TextEditingController(
                                        text: controller.rfc.value),
                                    validator: controller.validateRFC,
                                    onChanged: (value) =>
                                        controller.rfc.value = value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Right side - Observations
                    if (config.showObservations)
                      Expanded(
                        flex: config.observationsFlex ?? 1,
                        child: Column(
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
                            // Use SizedBox with fixed height to match personal data section
                            SizedBox(
                              height:
                                  280, // Taller to match all rows in left section
                              child: TextField(
                                controller: TextEditingController(
                                    text: controller.observaciones.value),
                                onChanged: (value) =>
                                    controller.observaciones.value = value,
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                style: theme.textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.secondary
                                          .withOpacity(0.6),
                                      width: 1.2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.secondary
                                          .withOpacity(0.4),
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.secondary,
                                      width: 1.5,
                                    ),
                                  ),
                                  hintText: 'Agregar observaciones...',
                                  hintStyle: TextStyle(color: theme.hintColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // COMPANY DATA SECTION (Bottom part)
              Text(
                'Datos de la Empresa',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Row 1: ID, Registration Date, Role
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
                      value: controller.fechaRegistro.value.isEmpty
                          ? DateTime.now().toString().split(' ')[0]
                          : controller.fechaRegistro.value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownForm(
                      label: 'Rol',
                      opciones: controller.roles,
                      value: controller.rol.value,
                      onChanged: (value) => controller.rol.value = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Row 2: Service Type
              Row(
                children: [
                  Expanded(
                    child: DropdownForm(
                      label: 'Tipo de Servicio',
                      opciones: controller.tiposServicio,
                      value: controller.tipoServicio.value,
                      onChanged: (value) =>
                          controller.tipoServicio.value = value!,
                    ),
                  ),
                  // Empty expanded widgets to maintain the same layout as above
                  const Expanded(child: SizedBox()),
                  const Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: 30),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonForm(
                    texto: config.secondaryButtonText ?? 'Cancelar',
                    onPressed: () => controller.resetForm(),
                    isPrimary: false,
                  ),
                  const SizedBox(width: 100),
                  ButtonForm(
                    texto: config.primaryButtonText ?? 'Registrar',
                    onPressed: () => controller.submitForm(),
                    icon: Icons.add,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
