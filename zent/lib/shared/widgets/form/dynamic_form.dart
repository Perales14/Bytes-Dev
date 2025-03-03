import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';
import 'package:zent/controllers/client_form_controller.dart';
import 'package:zent/controllers/employee_form_controller.dart';
import 'package:zent/shared/factories/form_factory.dart';
import 'package:zent/shared/models/form_config.dart';
import 'package:zent/shared/widgets/form/employee_form.dart';
import 'package:zent/shared/widgets/form/client_form.dart';

/// A dynamic form that can render different form types
/// This is a higher-level abstraction that simplifies form usage
class DynamicForm extends StatefulWidget {
  /// The type of form to display
  final FormType formType;

  /// Optional callback for handling form submission
  final Function(Map<String, dynamic>)? onSubmit;

  /// Optional custom configuration for the form
  final FormConfig? customConfig;

  const DynamicForm({
    required this.formType,
    this.onSubmit,
    this.customConfig,
    super.key,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late BaseFormController controller;
  late FormConfig config;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    switch (widget.formType) {
      case FormType.employee:
        // Use custom config or default employee config
        config = widget.customConfig ?? FormConfig.employee;
        controller = Get.put(EmployeeFormController() as BaseFormController);
        break;
      case FormType.client:
        // Use custom config or default client config
        config = widget.customConfig ?? FormConfig.client;
        controller = Get.put(ClientFormController());
        break;
      default:
        throw Exception('Unsupported form type: ${widget.formType}');
    }

    // Set the onSubmit callback if provided
    if (widget.onSubmit != null) {
      controller.setExternalSubmitHandler(widget.onSubmit!);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.formType) {
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
      default:
        return Center(
          child: Text(
            'Tipo de formulario no soportado: ${widget.formType}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the form is disposed
    // This prevents memory leaks for forms created temporarily
    Get.delete<BaseFormController>();
    super.dispose();
  }
}
