import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/employee_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';
import 'package:zent/shared/widgets/form/file_upload_panel.dart';
import 'package:zent/shared/widgets/form/reactive_form_field.dart';
import 'package:zent/shared/widgets/form/label_display.dart';

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
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título "REGISTRO DE EMPLEADO"
            Center(
              child: Text(
                config.title,
                style: theme.textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 30),

            // FILA 1: DATOS PERSONALES Y OBSERVACIONES
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DATOS PERSONALES (IZQUIERDA)
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos Personales',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Fila 1: Nombre, Apellido Paterno, Apellido Materno
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

                      // Fila 2: Correo Electrónico, Teléfono, NSS
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
                              label: 'NSS',
                              controller: TextEditingController(
                                  text: controller.nss.value),
                              validator: controller.validateNSS,
                              onChanged: (value) =>
                                  controller.nss.value = value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Fila 3: Contraseña y Confirmar Contraseña con visibilidad toggle
                      Row(
                        children: [
                          Expanded(
                            child: GetX<EmployeeFormController>(
                              builder: (ctrl) => TextFieldForm(
                                label: 'Contraseña',
                                obscureText: !ctrl.showPassword.value,
                                controller: TextEditingController(
                                    text: ctrl.password.value),
                                validator: ctrl.validatePassword,
                                onChanged: (value) =>
                                    ctrl.password.value = value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    ctrl.showPassword.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  onPressed: () =>
                                      ctrl.togglePasswordVisibility(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() {
                              final showConfirmPassword =
                                  controller.showConfirmPassword.value;
                              final confirmPasswordValue =
                                  controller.confirmPassword.value;
                              return TextFieldForm(
                                label: 'Confirmar Contraseña',
                                obscureText: !showConfirmPassword,
                                controller: TextEditingController(
                                    text: confirmPasswordValue),
                                validator: controller.validateConfirmPassword,
                                onChanged: (value) =>
                                    controller.confirmPassword.value = value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  onPressed: () => controller
                                      .toggleConfirmPasswordVisibility(),
                                ),
                              );
                            }),
                          ),
                          // Keep the third column balanced for consistent layout
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // OBSERVACIONES (DERECHA)
                if (config.showObservations)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Make text line up with "Datos Personales" header
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            'Observaciones',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Use SizedBox with specific height instead of Flexible
                        SizedBox(
                          height:
                              200, // Set explicit height to match files section
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

            const SizedBox(height: 30),

            // FILA 2: DATOS DE LA EMPRESA Y ARCHIVOS
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DATOS DE LA EMPRESA (IZQUIERDA)
                Expanded(
                  flex: 2,
                  child: Column(
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

                      // Fila 1: ID, Fecha de Registro, Rol
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
                            child: Obx(() {
                              final rolValue = controller.rol.value;
                              return DropdownForm(
                                label: 'Rol',
                                opciones: controller.roles,
                                value: rolValue,
                                onChanged: (value) =>
                                    controller.rol.value = value,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Fila 2: Tipo de Contrato, Salario
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final tipoContratoValue =
                                  controller.tipoContrato.value;
                              return DropdownForm(
                                label: 'Tipo de Contrato',
                                opciones: controller.tiposContrato,
                                value: tipoContratoValue,
                                onChanged: (value) =>
                                    controller.tipoContrato.value = value,
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFieldForm(
                              label: 'Salario',
                              controller: TextEditingController(
                                  text: controller.salario.value),
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  controller.salario.value = value,
                            ),
                          ),
                          // Empty column to maintain balance
                          const SizedBox(width: 10),
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // ARCHIVOS (DERECHA)
                if (config.showFiles)
                  Expanded(
                    flex: 1,
                    child: Column(
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
                        // Use SizedBox with specific height instead of Flexible
                        SizedBox(
                          height: 200, // Set explicit height
                          child: ValueListenableBuilder<List<FileData>>(
                            valueListenable: controller.filesNotifier,
                            builder: (context, files, _) {
                              return FileUploadPanel(
                                files: files,
                                onRemove: controller.removeFile,
                                onAdd: () => controller.addFile(FileData(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    name: 'Nuevo documento.pdf',
                                    type: FileType
                                        .pdf, // Assuming FileType.pdf exists in the enum
                                    uploadDate: DateTime.now())),
                              );
                            },
                          ),
                        ),
                      ],
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
    );
  }
}
