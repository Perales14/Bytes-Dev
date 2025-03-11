import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/employee_form_controller.dart';
import 'base_form.dart';
import 'widgets/dropdown_form.dart';
import 'widgets/file_upload_panel.dart';
import 'widgets/label_display.dart';
import 'widgets/text_field_form.dart';

class EmployeeForm extends BaseForm {
  // Constructor sin redeclaraciones problemáticas
  const EmployeeForm({
    required EmployeeFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

  // Accedemos al controller con el tipo correcto
  EmployeeFormController get employeeController =>
      controller as EmployeeFormController;

  @override
  Widget buildFormContent(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Importante para evitar expansión infinita
          children: [
            _buildPersonalDataSection(theme),
            const SizedBox(height: 20),
            if (config.showObservations) _buildObservationsSection(theme),
            const SizedBox(height: 20),
            _buildCompanyDataSection(theme),
            const SizedBox(height: 20),
            if (config.showFiles) _buildFilesSection(theme),
          ],
        ),
      ),
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
                controller: TextEditingController(
                    text: employeeController.model.nombre),
                validator: employeeController.validateRequired,
                onChanged: (value) =>
                    employeeController.updateBaseModel(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: employeeController.model.apellidoPaterno),
                validator: employeeController.validateRequired,
                onChanged: (value) =>
                    employeeController.updateBaseModel(apellidoPaterno: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: employeeController.model.apellidoMaterno),
                validator: employeeController.validateRequired,
                onChanged: (value) =>
                    employeeController.updateBaseModel(apellidoMaterno: value),
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
                controller: TextEditingController(
                    text: employeeController.model.correo),
                validator: employeeController.validateEmail,
                onChanged: (value) =>
                    employeeController.updateBaseModel(correo: value),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono',
                controller: TextEditingController(
                    text: employeeController.model.telefono),
                validator: employeeController.validateRequired,
                onChanged: (value) =>
                    employeeController.updateBaseModel(telefono: value),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'NSS',
                controller:
                    TextEditingController(text: employeeController.model.nss),
                validator: employeeController.validateNSS,
                onChanged: (value) =>
                    employeeController.updateEmployee(nss: value),
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
                obscureText: !employeeController.showPassword.value,
                controller: TextEditingController(
                    text: employeeController.model.password),
                validator: employeeController.validatePassword,
                onChanged: (value) =>
                    employeeController.updateEmployee(password: value),
                suffixIcon: IconButton(
                  icon: Icon(
                    employeeController.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: theme.colorScheme.secondary,
                  ),
                  onPressed: () =>
                      employeeController.togglePasswordVisibility(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Confirmar Contraseña',
                obscureText: !employeeController.showPassword.value,
                controller: TextEditingController(
                    text: employeeController.confirmPassword),
                validator: employeeController.validateConfirmPassword,
                onChanged: employeeController.updateConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    employeeController.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: theme.colorScheme.secondary,
                  ),
                  onPressed: () =>
                      employeeController.togglePasswordVisibility(),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ));
  }

  Widget _buildObservationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 20),
        TextFieldForm(
          label: 'Observaciones',
          controller: TextEditingController(
              text: employeeController.model.observaciones),
          onChanged: (value) =>
              employeeController.updateEmployee(observaciones: value),
          maxLines: 5,
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
                label: 'Fecha de Registro',
                value: employeeController.model.fechaRegistro,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownForm(
                label: 'Rol',
                opciones: employeeController.roles,
                value: employeeController.model.rol,
                onChanged: (value) =>
                    employeeController.updateEmployee(rol: value),
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
                opciones: employeeController.tiposContrato,
                value: employeeController.model.tipoContrato,
                onChanged: (value) =>
                    employeeController.updateEmployee(tipoContrato: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Salario',
                controller: TextEditingController(
                    text: employeeController.model.salario),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    employeeController.updateEmployee(salario: value),
                validator: employeeController.validateSalario,
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
            files: employeeController.model.files,
            onRemove: employeeController.removeFile,
            onAdd: () => employeeController.addFile(FileData(
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
