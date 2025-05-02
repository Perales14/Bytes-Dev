import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_form_controller.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../shared/widgets/form/widgets/dropdown_form.dart';
import '../../../shared/widgets/form/widgets/file_upload_panel.dart';
import '../../../shared/widgets/form/widgets/text_field_form.dart';
import 'utils/date_picker_form.dart';

class ProjectForm extends BaseForm {
  const ProjectForm({
    required ProjectFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  ProjectFormController get projectController =>
      controller as ProjectFormController;

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
            _buildProjectDetailsSection(theme),
            const SizedBox(height: 20),
            _buildDatesAndBudgetSection(theme),
            const SizedBox(height: 20),
            _buildDescriptionSection(theme),
            const SizedBox(height: 20),
            _buildAddressToggleSection(theme),
            Obx(() => projectController.showAddress.value
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildAddressSection(theme),
                    ],
                  )
                : Container()),
            if (config.showFiles) ...[
              const SizedBox(height: 20),
              _buildFilesSection(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Detalles del Proyecto'),
        const SizedBox(height: 20),
        TextFieldForm(
          label: 'Nombre del Proyecto',
          controller: projectController.nameController,
          validator: projectController.validateName,
          onChanged: (value) => projectController.updateProject(name: value),
        ),
        const SizedBox(height: 10),
        _buildProjectTeamRow(),
      ],
    );
  }

  Widget _buildProjectTeamRow() {
    return Obx(() {
      // Preparación de las listas de opciones para los dropdowns
      final clients = projectController.clients
          .map((client) => DropdownMenuItem(
                value: client.id.toString(),
                child: Text('${client.name} ${client.fatherLastName}'),
              ))
          .toList();

      final managers = projectController.managers
          .map((manager) => DropdownMenuItem(
                value: manager.id.toString(),
                child: Text('${manager.name} ${manager.fatherLastName}'),
              ))
          .toList();

      final providers = projectController.providers
          .map((provider) => DropdownMenuItem(
                value: provider.id.toString(),
                child: Text(provider.companyName),
              ))
          .toList();

      // Obtener los nombres actuales para mostrar como valores seleccionados
      String clientName = '';
      String managerName = '';
      String providerName = '';

      // Buscar y obtener el nombre del cliente seleccionado
      if (projectController.project.value.clientId > 0) {
        final selectedClient = projectController.clients.firstWhereOrNull(
            (c) => c.id == projectController.project.value.clientId);
        if (selectedClient != null) {
          clientName =
              '${selectedClient.name} ${selectedClient.fatherLastName}';
        }
      }

      // Buscar y obtener el nombre del responsable seleccionado
      if (projectController.project.value.managerId > 0) {
        final selectedManager = projectController.managers.firstWhereOrNull(
            (m) => m.id == projectController.project.value.managerId);
        if (selectedManager != null) {
          managerName =
              '${selectedManager.name} ${selectedManager.fatherLastName}';
        }
      }

      // Buscar y obtener el nombre del proveedor seleccionado
      if (projectController.project.value.providerId != null &&
          projectController.project.value.providerId! > 0) {
        final selectedProvider = projectController.providers.firstWhereOrNull(
            (p) => p.id == projectController.project.value.providerId);
        if (selectedProvider != null) {
          providerName = selectedProvider.companyName;
        }
      }

      return Column(
        children: [
          // Dropdown para seleccionar cliente
          DropdownForm(
            label: 'Cliente',
            opciones: projectController.clients
                .map((c) => '${c.name} ${c.fatherLastName}')
                .toList(),
            value: clientName.isNotEmpty ? clientName : null,
            onChanged: (value) {
              if (value != null) {
                // Buscar el id del cliente por su nombre completo
                final selectedClient = projectController.clients
                    .firstWhereOrNull(
                        (c) => '${c.name} ${c.fatherLastName}' == value);
                if (selectedClient != null) {
                  projectController.updateProject(clientId: selectedClient.id);
                }
              }
            },
            validator: projectController.validateClientId,
          ),
          const SizedBox(height: 10),

          // Dropdown para seleccionar responsable
          DropdownForm(
            label: 'Responsable',
            opciones: projectController.managers
                .map((m) => '${m.name} ${m.fatherLastName}')
                .toList(),
            value: managerName.isNotEmpty ? managerName : null,
            onChanged: (value) {
              if (value != null) {
                // Buscar el id del responsable por su nombre completo
                final selectedManager = projectController.managers
                    .firstWhereOrNull(
                        (m) => '${m.name} ${m.fatherLastName}' == value);
                if (selectedManager != null) {
                  projectController.updateProject(
                      managerId: selectedManager.id);
                }
              }
            },
            validator: projectController.validateManagerId,
          ),
          const SizedBox(height: 10),

          // Dropdown para seleccionar proveedor
          DropdownForm(
            label: 'Proveedor',
            opciones:
                projectController.providers.map((p) => p.companyName).toList(),
            value: providerName.isNotEmpty ? providerName : null,
            onChanged: (value) {
              if (value != null) {
                // Buscar el id del proveedor por su nombre
                final selectedProvider = projectController.providers
                    .firstWhereOrNull((p) => p.companyName == value);
                if (selectedProvider != null) {
                  projectController.updateProject(
                      providerId: selectedProvider.id);
                }
              }
            },
          ),
        ],
      );
    });
  }

  Widget _buildDatesAndBudgetSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Fechas y Presupuesto'),
        const SizedBox(height: 20),
        Obx(() => Row(
              children: [
                Expanded(
                  child: DatePickerForm(
                    label: 'Fecha de Inicio',
                    selectedDate: projectController.startDate.value,
                    onDateSelected: (date) =>
                        projectController.updateProject(startDate: date),
                    validator: (date) =>
                        date == null ? 'La fecha de inicio es requerida' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DatePickerForm(
                    label: 'Fecha de Fin Estimada',
                    selectedDate: projectController.estimatedEndDate.value,
                    onDateSelected: (date) {
                      // print('Antes de cambiar fecha: ${projectController.estimatedEndDate.value}');
                      projectController.updateProject(estimatedEndDate: date);
                      // print('Después de cambiar fecha: ${projectController.estimatedEndDate.value}');
                    },
                  ),
                  // =>
                  //     projectController.updateProject(estimatedEndDate: date),
                  //     ),
                ),
              ],
            )),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Presupuesto Estimado',
                controller: projectController.estimatedBudgetController,
                onChanged: (value) => projectController.updateProject(
                  estimatedBudget: double.tryParse(value),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Comisión (%)',
                controller: projectController.commissionController,
                onChanged: (value) => projectController.updateProject(
                  commissionPercentage: double.tryParse(value),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Descripción'),
        const SizedBox(height: 20),
        TextFieldForm(
          label: 'Descripción del Proyecto',
          controller: projectController.descriptionController,
          onChanged: (value) =>
              projectController.updateProject(description: value),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildAddressToggleSection(ThemeData theme) {
    return Obx(() => CheckboxListTile(
          title: Text('Agregar dirección', style: theme.textTheme.titleMedium),
          value: projectController.showAddress.value,
          onChanged: (value) {
            if (value != null) {
              projectController.toggleAddress();
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
            controller: projectController.streetController,
            validator: (value) => projectController.showAddress.value
                ? projectController.validateRequired(value)
                : null,
            onChanged: (value) =>
                projectController.updateAddress(street: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFieldForm(
            label: 'Número',
            controller: projectController.streetNumberController,
            validator: (value) => projectController.showAddress.value
                ? projectController.validateRequired(value)
                : null,
            onChanged: (value) =>
                projectController.updateAddress(streetNumber: value),
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
            controller: projectController.neighborhoodController,
            validator: (value) => projectController.showAddress.value
                ? projectController.validateRequired(value)
                : null,
            onChanged: (value) =>
                projectController.updateAddress(neighborhood: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFieldForm(
            label: 'Código Postal',
            controller: projectController.postalCodeController,
            validator: projectController.validatePostalCode,
            onChanged: (value) =>
                projectController.updateAddress(postalCode: value),
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
            controller: projectController.stateController,
            onChanged: (value) => projectController.updateAddress(state: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'País',
            controller: projectController.countryController,
            onChanged: (value) =>
                projectController.updateAddress(country: value),
          ),
        ),
      ],
    );
  }

  Widget _buildFilesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Archivos'),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: FileUploadPanel(
            files: projectController.files,
            onRemove: projectController.removeFile,
            onAdd: () => projectController.addNewFile(),
          ),
        ),
      ],
    );
  }
}
