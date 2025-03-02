import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/form_controller.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';

class DataForm extends GetView<FormController> {
  final bool showSalario;

  const DataForm({
    this.showSalario = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección 1: Datos Personales
        Text(
          'Datos Personales',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),

        // Fila 1: Nombre, Apellido Paterno, Apellido Materno
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Nombre:',
                controller:
                    TextEditingController(text: controller.nombre.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.nombre.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Paterno:',
                controller: TextEditingController(
                    text: controller.apellidoPaterno.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.apellidoPaterno.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Apellido Materno:',
                controller: TextEditingController(
                    text: controller.apellidoMaterno.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.apellidoMaterno.value = value,
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
                label: 'Correo Electrónico:',
                controller:
                    TextEditingController(text: controller.correo.value),
                validator: controller.validateEmail,
                onChanged: (value) => controller.correo.value = value,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Teléfono:',
                controller:
                    TextEditingController(text: controller.telefono.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.telefono.value = value,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'NSS:',
                controller: TextEditingController(text: controller.nss.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.nss.value = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Fila 3: Contraseña y Confirmar Contraseña
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'Contraseña:',
                obscureText: true,
                controller:
                    TextEditingController(text: controller.password.value),
                validator: controller.validatePassword,
                onChanged: (value) => controller.password.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Confirmar Contraseña:',
                obscureText: true,
                controller: TextEditingController(
                    text: controller.confirmPassword.value),
                validator: controller.validateConfirmPassword,
                onChanged: (value) => controller.confirmPassword.value = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Sección 2: Datos de la Empresa
        Text(
          'Datos de la Empresa',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),

        // Fila 4: ID, Fecha de Ingreso, Salario (condicional)
        Row(
          children: [
            Expanded(
              child: TextFieldForm(
                label: 'ID:',
                controller: TextEditingController(text: controller.id.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.id.value = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFieldForm(
                label: 'Fecha de Ingreso:',
                controller:
                    TextEditingController(text: controller.fechaIngreso.value),
                validator: controller.validateRequired,
                onChanged: (value) => controller.fechaIngreso.value = value,
              ),
            ),
            if (showSalario) const SizedBox(width: 10),
            if (showSalario)
              Expanded(
                child: TextFieldForm(
                  label: 'Salario:',
                  controller:
                      TextEditingController(text: controller.salario.value),
                  validator: controller.validateRequired,
                  onChanged: (value) => controller.salario.value = value,
                  keyboardType: TextInputType.number,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
