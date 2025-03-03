import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/client_form_controller.dart';
import 'package:zent/controllers/employee_form_controller.dart';
import 'package:zent/controllers/provider_form_controller.dart'; // Add import
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/client_form.dart';
import 'package:zent/shared/widgets/form/employee_form.dart';
import 'package:zent/shared/widgets/form/provider_form.dart'; // Add import

/// Form types available in the app
enum FormType {
  employee,
  client,
  provider, // Add provider type
}

/// Factory to create forms dynamically
class FormFactory {
  /// Create a form based on the given type
  static Widget createForm(FormType type) {
    switch (type) {
      case FormType.employee:
        // Register controller if not already registered
        if (!Get.isRegistered<EmployeeFormController>()) {
          Get.put(EmployeeFormController());
        }
        return EmployeeForm(
          controller: Get.find<EmployeeFormController>(),
          config: FormConfig(
            title: 'REGISTRO DE EMPLEADO',
            showObservations: true,
            observationsFlex: 1,
            primaryButtonText: 'Agregar',
            secondaryButtonText: 'Cancelar',
          ),
        );

      case FormType.client:
        // Register controller if not already registered
        if (!Get.isRegistered<ClientFormController>()) {
          Get.put(ClientFormController());
        }
        return ClientForm(
          controller: Get.find<ClientFormController>(),
          config: FormConfig(
            title: 'REGISTRO DE CLIENTE',
            showObservations: true,
            observationsFlex: 1,
            primaryButtonText: 'Agregar',
            secondaryButtonText: 'Cancelar',
          ),
        );

      case FormType.provider:
        // Register controller if not already registered
        if (!Get.isRegistered<ProviderFormController>()) {
          Get.put(ProviderFormController());
        }
        return ProviderForm(
          controller: Get.find<ProviderFormController>(),
          config: FormConfig(
            title: 'REGISTRO DE PROVEEDOR',
            showObservations: true,
            observationsFlex: 1,
            primaryButtonText: 'Agregar',
            secondaryButtonText: 'Cancelar',
          ),
        );
    }
  }
}
