import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/employee_form_controller.dart';
import '../../../shared/widgets/form/base_form.dart';
import '../../../shared/widgets/form/widgets/dropdown_form.dart';
import '../../../shared/widgets/form/widgets/file_upload_panel.dart';
import '../../../shared/widgets/form/widgets/label_display.dart';
import '../../../shared/widgets/form/widgets/text_field_form.dart';
import '../../../shared/widgets/form/widgets/observations_field.dart';

class EmployeeForm extends BaseForm {
  const EmployeeForm({
    required EmployeeFormController super.controller,
    required super.config,
    required super.onCancel,
    required super.onSubmit,
    super.key,
  });

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
          mainAxisSize: MainAxisSize.min,
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
        Obx(() => Row(
              children: [
                Expanded(
                  child: TextFieldForm(
                    label: 'Nombre',
                    controller: TextEditingController(
                        text: employeeController.usuario.value.nombre),
                    validator: employeeController.validateRequired,
                    onChanged: (value) =>
                        employeeController.updateUsuario(nombre: value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'Apellido Paterno',
                    controller: TextEditingController(
                        text: employeeController.usuario.value.apellidoPaterno),
                    validator: employeeController.validateRequired,
                    onChanged: (value) => employeeController.updateUsuario(
                        apellidoPaterno: value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'Apellido Materno',
                    controller: TextEditingController(
                        text:
                            employeeController.usuario.value.apellidoMaterno ??
                                ''),
                    onChanged: (value) => employeeController.updateUsuario(
                        apellidoMaterno: value),
                  ),
                ),
              ],
            )),
        const SizedBox(height: 10),

        // Correo, Teléfono, NSS
        Obx(() => Row(
              children: [
                Expanded(
                  child: TextFieldForm(
                    label: 'Correo Electrónico',
                    controller: TextEditingController(
                        text: employeeController.usuario.value.email),
                    validator: employeeController.validateEmail,
                    onChanged: (value) =>
                        employeeController.updateUsuario(email: value),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'Teléfono',
                    controller: TextEditingController(
                        text: employeeController.usuario.value.telefono ?? ''),
                    onChanged: (value) =>
                        employeeController.updateUsuario(telefono: value),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'NSS',
                    controller: TextEditingController(
                        text: employeeController.usuario.value.nss),
                    validator: employeeController.validateNSS,
                    onChanged: (value) =>
                        employeeController.updateUsuario(nss: value),
                  ),
                ),
              ],
            )),
        const SizedBox(height: 10),

        // Contraseña y Confirmación de Contraseña
        _buildPasswordSection(theme),
      ],
    );
  }

  Widget _buildPasswordSection(ThemeData theme) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Contraseña',
                obscureText: !employeeController.showPassword.value,
                controller: TextEditingController(
                    text: employeeController.usuario.value.contrasenaHash),
                validator: employeeController.usuario.value.id > 0
                    ? null
                    : employeeController.validatePassword,
                onChanged: (value) =>
                    employeeController.updateUsuario(contrasenaHash: value),
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
                    text: employeeController.confirmPassword.value),
                validator: employeeController.usuario.value.id > 0
                    ? null
                    : employeeController.validateConfirmPassword,
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
        SizedBox(
          height: 150,
          child: Obx(() => ObservationsField(
                initialValue: employeeController.observacionText.value,
                onChanged: (value) =>
                    employeeController.updateObservacion(value),
              )),
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

        // Fecha de ingreso y tipo contrato
        Obx(() => Row(
              children: [
                Expanded(
                  child: LabelDisplay(
                    label: 'Fecha de Ingreso',
                    value: employeeController.usuario.value.fechaIngreso
                        .toString()
                        .split(' ')[0],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownForm(
                    label: 'Tipo de Contrato',
                    opciones: employeeController.tiposContrato,
                    value: employeeController.usuario.value.tipoContrato,
                    onChanged: (value) =>
                        employeeController.updateUsuario(tipoContrato: value),
                    validator: employeeController.validateTipoContrato,
                  ),
                ),
              ],
            )),
        const SizedBox(height: 10),

        // Salario y rol
        Obx(() => Row(
              children: [
                Expanded(
                  child: TextFieldForm(
                    label: 'Salario',
                    controller: TextEditingController(
                        text: employeeController.usuario.value.salario
                                ?.toString() ??
                            ''),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => employeeController.updateUsuario(
                      salario: value.isEmpty ? null : double.tryParse(value),
                    ),
                    validator: employeeController.validateSalario,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownForm(
                    label: 'Rol',
                    opciones: employeeController.roles,
                    value: _getRolName(employeeController.usuario.value.rolId),
                    onChanged: (value) => employeeController.updateUsuario(
                      rolId: _getRolId(value!),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Container()),
              ],
            )),
      ],
    );
  }

  String? _getRolName(int rolId) {
    switch (rolId) {
      case 1:
        return 'Captador de Campo';
      case 2:
        return 'Admin';
      case 3:
        return 'Promotor';
      case 4:
        return 'Recursos Humanos';
      default:
        return null;
    }
  }

  int _getRolId(String rolName) {
    switch (rolName) {
      case 'Admin':
        return 2;
      case 'Captador de Campo':
        return 1;
      case 'Promotor':
        return 3;
      case 'Recursos Humanos':
        return 4;
      default:
        return 2;
    }
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
            files: employeeController.files,
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
