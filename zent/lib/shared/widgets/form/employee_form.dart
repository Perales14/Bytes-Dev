import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/employee_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';
import 'package:zent/shared/widgets/form/file_upload_panel.dart';
import 'package:zent/shared/widgets/form/reactive_form_field.dart';
import 'package:zent/shared/widgets/form/label_display.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/personal_data_section.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';

class EmployeeForm extends StatelessWidget {
  final EmployeeFormController controller;
  final FormConfig config;

  const EmployeeForm({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            _buildFormTitle(theme),
            const SizedBox(height: 30),

            // Datos personales y Observaciones
            _buildPersonalDataAndObservations(),
            const SizedBox(height: 30),

            // Datos de la empresa y archivos
            _buildCompanyDataAndFiles(),
            const SizedBox(height: 30),

            // Botones
            _buildActionButtons(),
          ],
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
          child: PersonalDataSection(
            controller: controller,
            showNSS: true,
            showPassword: true,
          ),
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

  Widget _buildObservationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text(
            'Observaciones',
            style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(
                  color: Theme.of(Get.context!).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
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

  Widget _buildCompanyDataAndFiles() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos de la empresa
        Expanded(
          flex: 2,
          child: _buildCompanyDataSection(),
        ),
        const SizedBox(width: 20),

        // Archivos
        if (config.showFiles)
          Expanded(
            flex: 1,
            child: _buildFilesSection(),
          ),
      ],
    );
  }

  Widget _buildCompanyDataSection() {
    final theme = Theme.of(Get.context!);

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

        // ID, Fecha de Registro, Rol
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
              child: Obx(() => DropdownForm(
                    label: 'Rol',
                    opciones: controller.roles,
                    value: controller.rol.value,
                    onChanged: (value) => controller.rol.value = value,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Tipo de Contrato, Salario
        Row(
          children: [
            Expanded(
              child: Obx(() => DropdownForm(
                    label: 'Tipo de Contrato',
                    opciones: controller.tiposContrato,
                    value: controller.tipoContrato.value,
                    onChanged: (value) => controller.tipoContrato.value = value,
                  )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Salario',
                controller:
                    TextEditingController(text: controller.salario.value),
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.salario.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildFilesSection() {
    final theme = Theme.of(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Archivos',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ValueListenableBuilder<List<FileData>>(
            valueListenable: controller.filesNotifier,
            builder: (context, files, _) {
              return FileUploadPanel(
                files: files,
                onRemove: controller.removeFile,
                onAdd: () => controller.addFile(FileData(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: 'Nuevo documento.pdf',
                    type: FileType.pdf,
                    uploadDate: DateTime.now())),
              );
            },
          ),
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
