import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/client_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';
import 'package:zent/shared/widgets/form/reactive_form_field.dart';
import 'package:zent/shared/widgets/form/label_display.dart';

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
    final controller = Get.find<ClientFormController>();

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
      // Use SingleChildScrollView to make the form scrollable
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título "REGISTRO DE CLIENTE"
              Center(
                child: Text(
                  config.title,
                  style: theme.textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 30),

              // FILA 1: DATOS DEL CLIENTE Y OBSERVACIONES
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DATOS DEL CLIENTE (IZQUIERDA)
                    Expanded(
                      flex: 2,
                      child: Column(
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

                          // Fila 1: ID, Fecha de Registro, Tipo de Cliente
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
                                child: ReactiveFormField<String?>(
                                  value: controller.tipoCliente,
                                  builder: (tipoClienteValue) => DropdownForm(
                                    label: 'Tipo de Cliente',
                                    opciones: controller.tiposCliente,
                                    value: tipoClienteValue,
                                    onChanged: (value) =>
                                        controller.tipoCliente.value = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Fila 2: Nombre, Apellido Paterno, Apellido Materno
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

                          // Fila 3: Correo Electrónico, Teléfono, RFC
                          Row(
                            children: [
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
                              Expanded(
                                child: TextFieldForm(
                                  label: 'RFC',
                                  controller: TextEditingController(
                                      text: controller.rfc.value),
                                  validator: controller.validateRFC,
                                  onChanged: (value) =>
                                      controller.rfc.value = value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // OBSERVACIONES (DERECHA) - Flex configurable
                    if (config.showObservations)
                      Expanded(
                        flex: config.observationsFlex,
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
                            // Fixed height for observations
                            SizedBox(
                              height:
                                  230, // Taller to match all client data rows
                              child: ReactiveFormField<String>(
                                value: controller.observaciones,
                                builder: (observaciones) => ObservationsField(
                                  initialValue: observaciones,
                                  onChanged: (value) =>
                                      controller.observaciones.value = value,
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

              // FILA 2: DATOS DE LA EMPRESA (ANCHO COMPLETO)
              Text(
                'Datos de la Empresa',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Fila 1: Nombre de la empresa, Cargo
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
                      controller:
                          TextEditingController(text: controller.cargo.value),
                      validator: controller.validateRequired,
                      onChanged: (value) => controller.cargo.value = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Fila 2: Calle y Número, Colonia, CP
              Row(
                children: [
                  Expanded(
                    child: TextFieldForm(
                      label: 'Calle y Número',
                      controller:
                          TextEditingController(text: controller.calle.value),
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
                      controller:
                          TextEditingController(text: controller.cp.value),
                      validator: controller.validateCP,
                      onChanged: (value) => controller.cp.value = value,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Botones CANCELAR y AGREGAR
              Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
