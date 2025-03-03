import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';

class PersonalDataSection extends StatelessWidget {
  final BaseFormController controller;
  final bool showNSS;
  final bool showPassword;

  const PersonalDataSection({
    required this.controller,
    this.showNSS = true,
    this.showPassword = true,
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
                    TextEditingController(text: controller.nombre.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.nombre.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno',
                controller: TextEditingController(
                    text: controller.apellidoPaterno.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.apellidoPaterno.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno',
                controller: TextEditingController(
                    text: controller.apellidoMaterno.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.apellidoMaterno.value = value,
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
            controller: TextEditingController(text: controller.correo.value),
            validator: controller.validateEmail,
            onChanged: (value) => controller.correo.value = value,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFieldForm(
            label: 'Teléfono',
            controller: TextEditingController(text: controller.telefono.value),
            validator: controller.validateRequired,
            onChanged: (value) => controller.telefono.value = value,
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
    // Aquí necesitamos un cast seguro para acceder al método validateNSS
    // Esto asume que el controller sea EmployeeFormController
    final employeeController = controller as dynamic;

    return TextFieldForm(
      label: 'NSS',
      controller:
          TextEditingController(text: employeeController.nss?.value ?? ''),
      validator: employeeController.validateNSS,
      onChanged: (value) => employeeController.nss?.value = value,
    );
  }

  Widget _buildPasswordFields(ThemeData theme) {
    // Aquí necesitamos un cast seguro para acceder a los campos de contraseña
    final employeeController = controller as dynamic;

    return Row(
      children: [
        Expanded(
          child: Obx(() => TextFieldForm(
                label: 'Contraseña',
                obscureText: !controller.showPassword.value,
                controller: TextEditingController(
                    text: employeeController.password?.value ?? ''),
                validator: employeeController.validatePassword,
                onChanged: (value) =>
                    employeeController.password?.value = value,
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
        Expanded(
          child: Obx(() => TextFieldForm(
                label: 'Confirmar Contraseña',
                obscureText: !controller.showConfirmPassword.value,
                controller: TextEditingController(
                    text: employeeController.confirmPassword?.value ?? ''),
                validator: employeeController.validateConfirmPassword,
                onChanged: (value) =>
                    employeeController.confirmPassword?.value = value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: theme.colorScheme.secondary,
                  ),
                  onPressed: () => controller.toggleConfirmPasswordVisibility(),
                ),
              )),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
