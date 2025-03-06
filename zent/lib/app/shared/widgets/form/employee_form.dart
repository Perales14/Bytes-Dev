import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/employee_form_controller.dart';
import 'package:zent/app/shared/models/form_config.dart';
import 'package:zent/app/shared/widgets/form/base_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/widgets/form/widgets/label_display.dart';
import 'package:zent/app/shared/widgets/form/widgets/dropdown_form.dart';
import 'package:zent/app/shared/widgets/form/widgets/text_field_form.dart';

class EmployeeForm extends BaseForm {
  @override
  final EmployeeFormController controller;

  const EmployeeForm({
    required this.controller,
    required super.config,
    super.key,
  }) : super(controller: controller);

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Datos personales y Observaciones
        _buildPersonalDataAndObservations(theme),
        const SizedBox(height: 30),

        // Datos de la empresa y archivos
        _buildCompanyDataAndFiles(theme),
      ],
    );
  }

  Widget _buildPersonalDataAndObservations(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos personales
        Expanded(
          flex: 2,
          child: _buildPersonalDataSection(theme),
        ),
        const SizedBox(width: 20),

        // Observaciones
        if (config.showObservations)
          Expanded(
            flex: config.observationsFlex,
            child: buildObservationsSection(
              theme,
              controller.model.observaciones,
              (value) => controller.updateEmployee(observaciones: value),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Datos Personales'),
        const SizedBox(height: 20),

        // Nombre, Apellido Paterno, Apellido Materno
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre',
                controller:
                    TextEditingController(text: controller.model.nombre),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateBaseModel(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: controller.model.apellidoPaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateBaseModel(apellidoPaterno: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: controller.model.apellidoMaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateBaseModel(apellidoMaterno: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Correo, Teléfono, NSS
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Correo Electrónico',
                controller:
                    TextEditingController(text: controller.model.correo),
                validator: controller.validateEmail,
                onChanged: (value) => controller.updateBaseModel(correo: value),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller:
                    TextEditingController(text: controller.model.telefono),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateBaseModel(telefono: value),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'NSS',
                controller: TextEditingController(text: controller.model.nss),
                validator: controller.validateNSS,
                onChanged: (value) => controller.updateEmployee(nss: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Contraseña y Confirmación de Contraseña
        _buildPasswordSection(theme),
      ],
    );
  }

  Widget _buildPasswordSection(ThemeData theme) {
    // Solo usamos Obx para el icono de mostrar/ocultar contraseña
    return Obx(() => Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Contraseña',
                obscureText: !controller.showPassword.value,
                controller:
                    TextEditingController(text: controller.model.password),
                validator: controller.validatePassword,
                onChanged: (value) =>
                    controller.updateEmployee(password: value),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: theme.colorScheme.secondary,
                  ),
                  onPressed: () => controller.togglePasswordVisibility(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Confirmar Contraseña',
                obscureText: !controller.showPassword.value,
                controller:
                    TextEditingController(text: controller.confirmPassword),
                validator: controller.validateConfirmPassword,
                onChanged: controller.updateConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: theme.colorScheme.secondary,
                  ),
                  onPressed: () => controller.togglePasswordVisibility(),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ));
  }

  Widget _buildCompanyDataAndFiles(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos de la empresa
        Expanded(
          flex: 2,
          child: _buildCompanyDataSection(theme),
        ),
        const SizedBox(width: 20),

        // Archivos
        if (config.showFiles)
          Expanded(
            child: _buildFilesSection(theme),
          ),
      ],
    );
  }

  Widget _buildCompanyDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Datos de la Empresa'),
        const SizedBox(height: 20),

        // ID, Fecha de Registro, Rol
        Row(
          children: [
            Expanded(
              child: LabelDisplay(
                label: 'ID',
                value: controller.model.id ?? 'Auto-generado',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabelDisplay(
                label: 'Fecha de Registro',
                value: controller.model.fechaRegistro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownForm(
                label: 'Rol',
                opciones: controller.roles,
                value: controller.model.rol,
                onChanged: (value) => controller.updateEmployee(rol: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Tipo de Contrato, Salario
        Row(
          children: [
            Expanded(
              child: DropdownForm(
                label: 'Tipo de Contrato',
                opciones: controller.tiposContrato,
                value: controller.model.tipoContrato,
                onChanged: (value) =>
                    controller.updateEmployee(tipoContrato: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Salario',
                controller:
                    TextEditingController(text: controller.model.salario),
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.updateEmployee(salario: value),
                validator: controller.validateSalario,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Container()),
          ],
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
            files: controller.model.files,
            onRemove: controller.removeFile,
            onAdd: () => controller.addFile(FileData(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: 'Nuevo documento.pdf',
                type: FileType.pdf,
                uploadDate: DateTime.now())),
          ),
        ),
      ],
    );
  }
}
