import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/form_controller.dart';
import 'package:zent/shared/widgets/form/button_form.dart';
import 'package:zent/shared/widgets/form/data_form.dart';
import 'package:zent/shared/widgets/form/dropdown_form.dart';
import 'package:zent/shared/widgets/form/text_field_form.dart';

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

            // Contenedor Principal
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección Izquierda: Datos Personales y Datos de la Empresa
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Datos personales
                      DataForm(
                        showSalario: showSalario,
                      ),
                      const SizedBox(height: 20),

                      // Fila: Rol y Tipo de Contrato
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: DropdownForm(
                                  label: 'Rol',
                                  opciones: controller.roles,
                                  value: controller.rol.value,
                                  onChanged: (value) =>
                                      controller.rol.value = value,
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
                            ],
                          )),
                    ],
                  ),
                ),

                // Espacio entre las secciones
                const SizedBox(width: 20),

                // Sección Derecha: Observaciones
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observaciones',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFieldForm(
                        label: '',
                        controller: TextEditingController(
                            text: controller.observaciones.value),
                        onChanged: (value) =>
                            controller.observaciones.value = value,
                        maxLines: 15,
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
