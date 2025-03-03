import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/form_controller.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/observations_field.dart';

class CustomForm extends GetView<FormController> {
  final bool showSalario;

  const CustomForm({
    this.showSalario = true,
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
            // Título "FORMULARIO"
            Center(
              child: Text(
                'FORMULARIO',
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

                      // Fila: Nombre, Apellido Paterno, Apellido Materno
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

                      // Fila: Correo Electrónico, Teléfono, NSS
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
                              validator: controller.validateRequired,
                              onChanged: (value) =>
                                  controller.nss.value = value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Fila: Contraseña y Confirmar Contraseña con visibilidad toggle
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => TextFieldForm(
                                  label: 'Contraseña',
                                  obscureText: !controller.showPassword.value,
                                  controller: TextEditingController(
                                      text: controller.password.value),
                                  validator: controller.validatePassword,
                                  onChanged: (value) =>
                                      controller.password.value = value,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.showPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    onPressed: () =>
                                        controller.togglePasswordVisibility(),
                                  ),
                                )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => TextFieldForm(
                                  label: 'Confirmar Contraseña',
                                  obscureText:
                                      !controller.showConfirmPassword.value,
                                  controller: TextEditingController(
                                      text: controller.confirmPassword.value),
                                  validator: controller.validateConfirmPassword,
                                  onChanged: (value) =>
                                      controller.confirmPassword.value = value,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.showConfirmPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    onPressed: () => controller
                                        .toggleConfirmPasswordVisibility(),
                                  ),
                                )),
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
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observaciones',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => ObservationsField(
                            initialValue: controller.observaciones.value,
                            onChanged: (value) =>
                                controller.observaciones.value = value,
                          )),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // FILA 2: DATOS DE LA EMPRESA (ANCHO COMPLETO)
            Text(
              'Datos de la Empresa',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Company data fields - Row 1: ID, Fecha Ingreso, Salario
            Row(
              children: [
                Expanded(
                  child: TextFieldForm(
                    label: 'ID',
                    controller:
                        TextEditingController(text: controller.id.value),
                    onChanged: (value) => controller.id.value = value,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldForm(
                    label: 'Fecha de Ingreso',
                    controller: TextEditingController(
                        text: controller.fechaIngreso.value),
                    onChanged: (value) => controller.fechaIngreso.value = value,
                  ),
                ),
                if (showSalario) const SizedBox(width: 10),
                if (showSalario)
                  Expanded(
                    child: TextFieldForm(
                      label: 'Salario',
                      controller:
                          TextEditingController(text: controller.salario.value),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.salario.value = value,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Company data fields - Row 2: Rol y Tipo de Contrato
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: DropdownForm(
                        label: 'Rol',
                        opciones: controller.roles,
                        value: controller.rol.value,
                        onChanged: (value) => controller.rol.value = value,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownForm(
                        label: 'Tipo de Contrato',
                        opciones: controller.tiposContrato,
                        value: controller.tipoContrato.value,
                        onChanged: (value) =>
                            controller.tipoContrato.value = value,
                      ),
                    ),
                    if (showSalario) const SizedBox(width: 10),
                    if (showSalario) Expanded(child: Container()),
                  ],
                )),

            const SizedBox(height: 30),

            // Botones CANCELAR y AGREGAR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonForm(
                  texto: 'CANCELAR',
                  onPressed: () => controller.resetForm(),
                  isPrimary: false,
                ),
                const SizedBox(width: 100),
                ButtonForm(
                  texto: 'AGREGAR',
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
