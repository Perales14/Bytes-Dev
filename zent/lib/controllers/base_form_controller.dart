import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Base controller for all forms
abstract class BaseFormController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // External submit handler - changing from private to protected
  Function(Map<String, dynamic>)? externalSubmitHandler;

  /// Set an external submit handler to be called when the form is submitted
  void setExternalSubmitHandler(Function(Map<String, dynamic>) handler) {
    externalSubmitHandler = handler;
  }

  /// Get form data as a map
  Map<String, dynamic> getFormData();

  /// Reset form fields to initial values
  void resetForm();

  /// Validate and submit the form
  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      // Get the form data
      final formData = getFormData();

      // Call external handler if provided
      if (externalSubmitHandler != null) {
        externalSubmitHandler!(formData);
      } else {
        // Default success message
        Get.snackbar(
          'Éxito',
          'Formulario enviado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
