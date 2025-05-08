import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_form_controller.dart';
import '../../../../../shared/widgets/form/base_form.dart';
import '../../../../../shared/widgets/form/widgets/text_field_form.dart';
import '../../../../../shared/widgets/form/widgets/dropdown_form.dart';
import '../../../../../shared/widgets/form/widgets/observations_field.dart';
import '../../../../../shared/widgets/form/widgets/description_field.dart';
import '../../../../../../app/modules/projects/widgets/utils/date_picker_form.dart';

class ActivityForm extends BaseForm {
  const ActivityForm({
    required ActivityFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  ActivityFormController get activityController =>
      controller as ActivityFormController;

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
            _buildBasicDetailsSection(theme),
            const SizedBox(height: 20),
            _buildDatesSection(theme),
            const SizedBox(height: 20),
            _buildResponsibleAndStateSection(theme),
            const SizedBox(height: 20),
            _buildDependencySection(theme),
            const SizedBox(height: 20),
            _buildDescriptionSection(theme),
            const SizedBox(height: 20),
            _buildObservationsSection(theme),
          ],
        ),
      ),
    );
  }

  // Sección de detalles básicos (título)
  Widget _buildBasicDetailsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextFieldForm(
          label: 'Título',
          controller: activityController.titleController,
          validator: activityController.validateTitle,
          onChanged: (value) => activityController.updateActivity(title: value),
        ),
      ],
    );
  }

  // Sección de fechas (inicio y fin)
  Widget _buildDatesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Obx(() => Row(
              children: [
                Expanded(
                  child: DatePickerForm(
                    label: 'Fecha de Inicio',
                    selectedDate: activityController.startDate.value,
                    onDateSelected: (date) =>
                        activityController.updateActivity(startDate: date),
                    validator: (date) =>
                        date == null ? 'La fecha de inicio es requerida' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DatePickerForm(
                    label: 'Fecha de Fin',
                    selectedDate: activityController.endDate.value,
                    onDateSelected: (date) =>
                        activityController.updateActivity(endDate: date),
                    hint: 'Opcional',
                  ),
                ),
              ],
            )),
      ],
    );
  }

  // Sección de responsable y estado
  Widget _buildResponsibleAndStateSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Obx(() => Row(
              children: [
                // Dropdown de responsables
                Expanded(
                  flex: 3,
                  child: _buildManagerDropdown(),
                ),
                const SizedBox(width: 16),
                // Dropdown de estados
                Expanded(
                  flex: 2,
                  child: _buildStateDropdown(),
                ),
              ],
            )),
      ],
    );
  }

  // Dropdown para seleccionar responsable
  Widget _buildManagerDropdown() {
    // Preparar opciones y valor seleccionado
    final managers = activityController.managers
        .map((manager) => '${manager.name} ${manager.fatherLastName}')
        .toList();

    String? selectedManagerName;
    if (activityController.activity.value.managerId != null) {
      final selectedManager = activityController.managers.firstWhereOrNull(
          (m) => m.id == activityController.activity.value.managerId);
      if (selectedManager != null) {
        selectedManagerName =
            '${selectedManager.name} ${selectedManager.fatherLastName}';
      }
    }

    return DropdownForm(
      label: 'Responsable',
      opciones: managers,
      value: selectedManagerName,
      onChanged: (value) {
        if (value != null) {
          final selectedManager = activityController.managers.firstWhereOrNull(
              (m) => '${m.name} ${m.fatherLastName}' == value);
          if (selectedManager != null) {
            activityController.updateActivity(managerId: selectedManager.id);
          }
        }
      },
    );
  }

  // Dropdown para seleccionar estado
  Widget _buildStateDropdown() {
    // Usando IDs unificados para los estados
    final states = {
      1: 'Sin comenzar',
      2: 'En progreso',
      3: 'Finalizado',
      4: 'Cancelado',
      5: 'Archivado',
    };

    final stateOptions = states.values.toList();
    final currentStateId = activityController.activity.value.stateId;
    final currentStateName = states[currentStateId] ?? 'Sin comenzar';

    return DropdownForm(
      label: 'Estado',
      opciones: stateOptions,
      value: currentStateName,
      onChanged: (value) {
        if (value != null) {
          final stateId = states.entries
              .firstWhere((entry) => entry.value == value,
                  orElse: () => const MapEntry(1, 'Sin comenzar'))
              .key;
          activityController.updateActivity(stateId: stateId);
        }
      },
    );
  }

  // Sección de dependencia (actividad previa necesaria)
  Widget _buildDependencySection(ThemeData theme) {
    return Obx(() {
      // Si no hay actividades o solo está esta, no mostrar sección
      if (activityController.dependencies.isEmpty ||
          (activityController.dependencies.length == 1 &&
              activityController.dependencies[0].id ==
                  activityController.activity.value.id)) {
        return Container(); // No mostrar nada
      }

      // Preparar opciones para el dropdown
      final dependencyOptions = ["Ninguna"] +
          activityController.dependencies
              .where((a) =>
                  a.id !=
                  activityController
                      .activity.value.id) // Filtrar actividad actual
              .map((a) => a.title ?? 'Actividad ${a.id}')
              .toList();

      // Determinar valor seleccionado
      String? selectedDependency = "Ninguna";
      if (activityController.activity.value.dependencyId != null) {
        final dep = activityController.dependencies.firstWhereOrNull(
            (d) => d.id == activityController.activity.value.dependencyId);
        if (dep != null) {
          selectedDependency = dep.title ?? 'Actividad ${dep.id}';
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          DropdownForm(
            label: 'Depende de',
            opciones: dependencyOptions,
            value: selectedDependency,
            onChanged: (value) {
              if (value != null) {
                if (value == "Ninguna") {
                  activityController.updateActivity(dependencyId: null);
                } else {
                  final selectedDep = activityController.dependencies
                      .firstWhereOrNull(
                          (d) => (d.title ?? 'Actividad ${d.id}') == value);
                  if (selectedDep != null) {
                    activityController.updateActivity(
                        dependencyId: selectedDep.id);
                  }
                }
              }
            },
          ),
        ],
      );
    });
  }

  // Sección de descripción
  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Descripción'),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: DescriptionField(
            initialValue: activityController.descriptionController.text,
            onChanged: (value) {
              activityController.descriptionController.text = value;
              activityController.updateActivity(description: value);
            },
          ),
        ),
      ],
    );
  }

  // Sección de observaciones
  Widget _buildObservationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ObservationsField(
            initialValue: activityController.observationText.value,
            onChanged: (value) {
              activityController.updateObservation(value);
            },
          ),
        ),
      ],
    );
  }
}
