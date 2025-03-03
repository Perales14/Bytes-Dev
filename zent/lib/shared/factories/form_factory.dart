import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/client_form_controller.dart';
import 'package:zent/controllers/employee_form_controller.dart';
import 'package:zent/controllers/provider_form_controller.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/client_form.dart';
import 'package:zent/shared/widgets/form/employee_form.dart';
import 'package:zent/shared/widgets/form/provider_form.dart';

enum FormType {
  employee,
  client,
  provider,
}

class FormFactory {
  static Widget createForm(FormType type) {
    // Usamos un mapa para reducir el código repetitivo
    final formConfigMap = {
      FormType.employee: FormConfig(
        title: 'REGISTRO DE EMPLEADO',
        showObservations: true,
        observationsFlex: 1,
        showFiles: true,
        primaryButtonText: 'Agregar',
        secondaryButtonText: 'Cancelar',
      ),
      FormType.client: FormConfig(
        title: 'REGISTRO DE CLIENTE',
        showObservations: true,
        observationsFlex: 1,
        primaryButtonText: 'Agregar',
        secondaryButtonText: 'Cancelar',
      ),
      FormType.provider: FormConfig(
        title: 'REGISTRO DE PROVEEDOR',
        showObservations: true,
        observationsFlex: 1,
        primaryButtonText: 'Agregar',
        secondaryButtonText: 'Cancelar',
      ),
    };

    switch (type) {
      case FormType.employee:
        return _getEmployeeForm(formConfigMap[type]!);
      case FormType.client:
        return _getClientForm(formConfigMap[type]!);
      case FormType.provider:
        return _getProviderForm(formConfigMap[type]!);
    }
  }

  static Widget _getEmployeeForm(FormConfig config) {
    if (!Get.isRegistered<EmployeeFormController>()) {
      Get.put(EmployeeFormController());
    }
    return EmployeeForm(
      controller: Get.find<EmployeeFormController>(),
      config: config,
    );
  }

  static Widget _getClientForm(FormConfig config) {
    if (!Get.isRegistered<ClientFormController>()) {
      Get.put(ClientFormController());
    }
    return ClientForm(
      controller: Get.find<ClientFormController>(),
      config: config,
    );
  }

  static Widget _getProviderForm(FormConfig config) {
    if (!Get.isRegistered<ProviderFormController>()) {
      Get.put(ProviderFormController());
    }
    return ProviderForm(
      controller: Get.find<ProviderFormController>(),
      config: config,
    );
  }
}
