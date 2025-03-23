import 'package:get/get.dart';

/// Valida que el código postal tenga un formato válido (5 dígitos para México)
String? validate_CP(String? value) {
  if (value == null || value.isEmpty) {
    return 'El código postal es requerido';
  }
  if (value.length != 5 || !GetUtils.isNumericOnly(value)) {
    return 'Ingrese un código postal válido (5 dígitos)';
  }
  return null;
}
