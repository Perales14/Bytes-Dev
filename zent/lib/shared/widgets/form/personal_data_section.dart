import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/controllers/employee_form_controller.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';

class PersonalDataSection extends StatelessWidget {
  final BaseFormController controller;
  final bool showNSS;
  final bool showPassword;

  const PersonalDataSection({
    required this.controller,
    this.showNSS = false,
    this.showPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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

        // Nombre, Apellido Paterno, Apellido Materno
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre',
                controller:
                    TextEditingController(text: controller.model_base.nombre),
                validator: controller.validateRequired,
                onChanged: (value) => controller.updateBaseModel(nombre: value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: controller.model_base.apellidoPaterno),
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
                    text: controller.model_base.apellidoMaterno),
                validator: controller.validateRequired,
                onChanged: (value) =>
                    controller.updateBaseModel(apellidoMaterno: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        _buildContactInfo(theme),

        if (showPassword) const SizedBox(height: 10),
        if (showPassword) _buildPasswordFields(theme),
      ],
    );
  }

  Widget _buildContactInfo(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFieldForm(
            label: 'Correo Electrónico',
            controller:
                TextEditingController(text: controller.model_base.correo),
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
                TextEditingController(text: controller.model_base.telefono),
            validator: controller.validateRequired,
            onChanged: (value) => controller.updateBaseModel(telefono: value),
            keyboardType: TextInputType.phone,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: showNSS ? _buildNSSField() : Container(),
        ),
      ],
    );
  }

  Widget _buildNSSField() {
    // Verificar que el controller sea un EmployeeFormController
    if (controller is EmployeeFormController) {
      final employeeController = controller as EmployeeFormController;

      return TextFieldForm(
        label: 'NSS',
        controller: TextEditingController(text: employeeController.model.nss),
        validator: employeeController.validateNSS,
        onChanged: (value) => employeeController.updateEmployee(nss: value),
      );
    }

    // Fallback si no es el tipo correcto
    return Container();
  }

  Widget _buildPasswordFields(ThemeData theme) {
    // Verificar que el controller sea un EmployeeFormController
    if (controller is EmployeeFormController) {
      final employeeController = controller as EmployeeFormController;

      return Row(
        children: [
          Expanded(
            child: Obx(() => TextFieldForm(
                  label: 'Contraseña',
                  obscureText: !controller.showPassword.value,
                  controller: TextEditingController(
                      text: employeeController.model.password),
                  validator: employeeController.validatePassword,
                  onChanged: (value) =>
                      employeeController.updateEmployee(password: value),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.showPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: theme.colorScheme.secondary,
                    ),
                    onPressed: () => controller.togglePasswordVisibility(),
                  ),
                )),
          ),
          const SizedBox(width: 10),
          Expanded(child: Container()),
          Expanded(child: Container()),
        ],
      );
    }

    // Fallback si no es el tipo correcto
    return Container();
  }
}
