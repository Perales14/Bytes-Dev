import 'package:get/get.dart';

/// Valida que el teléfono tenga un formato válido (10 dígitos para México)
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'El teléfono es requerido';
  }

  if (!GetUtils.isNumericOnly(value)) {
    return 'El teléfono debe contener solo números';
  }

  if (value.length != 10) {
    return 'El teléfono debe tener 10 dígitos';
  }

  return null;
}
