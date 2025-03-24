import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/provider_form_controller.dart';
import '../../../shared/models/form_config.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../shared/widgets/form/widgets/text_field_form.dart';
import '../../../shared/widgets/form/widgets/dropdown_form.dart';
import '../../../shared/widgets/form/widgets/observations_field.dart';

class ProviderForm extends BaseForm {
  const ProviderForm({
    required ProviderFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  ProviderFormController get providerController =>
      controller as ProviderFormController;

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
            Obx(() {
              if (providerController.showDireccion.value) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildAddressSection(theme),
                  ],
                );
              } else {
                return Container();
              }
            }),
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

            // Especialidad y nombre de empresa
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (providerController.isLoadingEspecialidades.value) {
                      return const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final especialidadActual =
                        providerController.getCurrentEspecialidad();

                    return DropdownForm(
                      label: 'Especialidad',
                      opciones: providerController.especialidades
                          .map((esp) => esp.nombre)
                          .toList(),
                      value: especialidadActual?.nombre ??
                          (providerController.especialidades.isNotEmpty
                              ? providerController.especialidades.first.nombre
                              : 'Cargando...'),
                      onChanged: (value) {
                        final especialidad =
                            providerController.especialidades.firstWhere(
                          (esp) => esp.nombre == value,
                          orElse: () => providerController.especialidades.first,
                        );
                        providerController.updateProveedor(
                            especialidadId: especialidad.id);
                      },
                      validator: providerController.validateRequired,
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextFieldForm(
                    label: 'Nombre de la Empresa',
                    controller: TextEditingController(
                        text: providerController.proveedor.value.nombreEmpresa),
                    validator: providerController.validateRequired,
                    onChanged: (value) => providerController.updateProveedor(
                        nombreEmpresa: value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tipo de servicio y condiciones de pago
            Row(
              children: [
                Expanded(
                  child: DropdownForm(
                    label: 'Tipo de Servicio',
                    opciones: providerController.tiposServicio,
                    value: providerController.proveedor.value.tipoServicio,
                    validator: providerController.validateTipoServicio,
                    onChanged: (value) =>
                        providerController.updateProveedor(tipoServicio: value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownForm(
                    label: 'Condiciones de Pago',
                    opciones: providerController.condicionesPago,
                    value: providerController.proveedor.value.condicionesPago,
                    validator: providerController.validateCondicionesPago,
                    onChanged: (value) => providerController.updateProveedor(
                        condicionesPago: value),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildContactSection(ThemeData theme) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle(theme, 'Información de Contacto'),
            const SizedBox(height: 20),

            // Contacto principal
            TextFieldForm(
              label: 'Contacto Principal',
              controller: TextEditingController(
                  text: providerController.proveedor.value.contactoPrincipal ??
                      ''),
              onChanged: (value) =>
                  providerController.updateProveedor(contactoPrincipal: value),
            ),
            const SizedBox(height: 10),

            // Teléfono, Email, RFC
            Row(
              children: [
                Expanded(
                  child: TextFieldForm(
                    label: 'Teléfono',
                    controller: TextEditingController(
                        text:
                            providerController.proveedor.value.telefono ?? ''),
                    onChanged: (value) =>
                        providerController.updateProveedor(telefono: value),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'Email',
                    controller: TextEditingController(
                        text: providerController.proveedor.value.email ?? ''),
                    validator: providerController.validateEmail,
                    onChanged: (value) =>
                        providerController.updateProveedor(email: value),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'RFC',
                    controller: TextEditingController(
                        text: providerController.proveedor.value.rfc ?? ''),
                    validator: providerController.validateRFC,
                    onChanged: (value) =>
                        providerController.updateProveedor(rfc: value),
                  ),
                ),
              ],
            ),
          ],
        ));
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
                initialValue: providerController.observacionText.value,
                onChanged: (value) =>
                    providerController.updateObservacion(value),
              )),
        ),
      ],
    );
  }

  Widget _buildAddressToggleSection(ThemeData theme) {
    return Obx(() => CheckboxListTile(
          title: Text('Agregar dirección', style: theme.textTheme.titleMedium),
          value: providerController.showDireccion.value,
          onChanged: (value) {
            if (value != null) {
              providerController.showDireccion.value = value;
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

        // Calle y número
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFieldForm(
                label: 'Calle',
                controller: TextEditingController(
                    text: providerController.direccion.calle),
                validator: (value) => providerController.showDireccion.value
                    ? providerController.validateRequired(value)
                    : null,
                onChanged: (value) =>
                    providerController.updateDireccion(calle: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextFieldForm(
                label: 'Número',
                controller: TextEditingController(
                    text: providerController.direccion.numero),
                validator: (value) => providerController.showDireccion.value
                    ? providerController.validateRequired(value)
                    : null,
                onChanged: (value) =>
                    providerController.updateDireccion(numero: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Colonia y CP
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFieldForm(
                label: 'Colonia',
                controller: TextEditingController(
                    text: providerController.direccion.colonia),
                validator: (value) => providerController.showDireccion.value
                    ? providerController.validateRequired(value)
                    : null,
                onChanged: (value) =>
                    providerController.updateDireccion(colonia: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextFieldForm(
                label: 'Código Postal',
                controller: TextEditingController(
                    text: providerController.direccion.cp),
                validator: providerController.validateCP,
                onChanged: (value) =>
                    providerController.updateDireccion(cp: value),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Estado y país
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Estado',
                controller: TextEditingController(
                    text: providerController.direccion.estado ?? ''),
                onChanged: (value) =>
                    providerController.updateDireccion(estado: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'País',
                controller: TextEditingController(
                    text: providerController.direccion.pais ?? 'México'),
                onChanged: (value) =>
                    providerController.updateDireccion(pais: value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
