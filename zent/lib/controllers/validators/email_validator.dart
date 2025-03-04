import 'package:get/get.dart';

/// Valida que el correo electrónico tenga un formato válido
String? validate_Email(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo electrónico es requerido';
  }
  if (!GetUtils.isEmail(value)) {
    return 'Ingrese un correo electrónico válido';
  }
  return null;
}
