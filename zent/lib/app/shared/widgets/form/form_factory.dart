import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/base_form_controller.dart';
import 'package:zent/app/shared/controllers/client_form_controller.dart';
import 'package:zent/app/shared/controllers/employee_form_controller.dart';
import 'package:zent/app/shared/controllers/provider_form_controller.dart';
import 'package:zent/app/shared/factories/form_factory.dart';
import 'package:zent/app/shared/models/form_config.dart';
import 'package:zent/app/shared/widgets/form/client_form.dart';
import 'package:zent/app/shared/widgets/form/employee_form.dart';
import 'package:zent/app/shared/widgets/form/provider_form.dart';

/// Factory para crear formularios según el tipo especificado
class FormFactory extends StatelessWidget {
  /// El tipo de formulario a mostrar
  final FormType formType;

  /// Configuración personalizada opcional
  final FormConfig? customConfig;

  /// Tag único para el controlador con GetX
  final String? controllerTag;

  const FormFactory({
    required this.formType,
    this.customConfig,
    this.controllerTag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Inicializa el controlador con un tag único si se proporciona
    final controller = _initializeController();

    // Determina la configuración a usar
    final config = customConfig ?? _getDefaultConfig();

    // Renderiza el formulario apropiado
    return _buildFormByType(controller, config);
  }

  BaseFormController _initializeController() {
    // Crea o encuentra el controlador adecuado
    switch (formType) {
      case FormType.employee:
        return _getOrCreateController<EmployeeFormController>(
          () => EmployeeFormController(),
        );
      case FormType.client:
        return _getOrCreateController<ClientFormController>(
          () => ClientFormController(),
        );
      case FormType.provider:
        return _getOrCreateController<ProviderFormController>(
          () => ProviderFormController(),
        );
    }
  }

  T _getOrCreateController<T extends BaseFormController>(
      T Function() createFn) {
    if (controllerTag != null) {
      if (!Get.isRegistered<T>(tag: controllerTag)) {
        Get.put<T>(createFn(), tag: controllerTag);
      }
      return Get.find<T>(tag: controllerTag);
    } else {
      if (!Get.isRegistered<T>()) {
        Get.put<T>(createFn());
      }
      return Get.find<T>();
    }
  }

  FormConfig _getDefaultConfig() {
    switch (formType) {
      case FormType.employee:
        return FormConfig(
          title: 'REGISTRO DE EMPLEADO',
          showObservations: true,
          showFiles: true,
          observationsFlex: 1,
          primaryButtonText: 'Agregar',
          secondaryButtonText: 'Cancelar',
        );
      case FormType.client:
        return FormConfig(
          title: 'REGISTRO DE CLIENTE',
          showObservations: true,
          observationsFlex: 1,
          primaryButtonText: 'Agregar',
          secondaryButtonText: 'Cancelar',
        );
      case FormType.provider:
        return FormConfig(
          title: 'REGISTRO DE PROVEEDOR',
          showObservations: true,
          observationsFlex: 1,
          primaryButtonText: 'Agregar',
          secondaryButtonText: 'Cancelar',
        );
    }
  }

  Widget _buildFormByType(BaseFormController controller, FormConfig config) {
    switch (formType) {
      case FormType.employee:
        return EmployeeForm(
          controller: controller as EmployeeFormController,
          config: config,
        );
      case FormType.client:
        return ClientForm(
          controller: controller as ClientFormController,
          config: config,
        );
      case FormType.provider:
        return ProviderForm(
          controller: controller as ProviderFormController,
          config: config,
        );
    }
  }
}
