import 'package:get/get.dart';

/// Valida que el Número de Seguridad Social (NSS) tenga el formato correcto
String? validate_NSS(String? value) {
  if (value == null || value.isEmpty) {
    return 'El NSS es requerido';
  }

  // Validar que solo contenga números
  if (!GetUtils.isNumericOnly(value)) {
    return 'El NSS debe contener solo dígitos';
  }

  // Validar longitud (11 dígitos para NSS mexicano)
  if (value.length != 11) {
    return 'El NSS debe tener 11 dígitos';
  }

  // Verificar que los primeros dos dígitos (subclave de estado) tengan sentido
  // Las subclaves van desde 01 hasta aproximadamente 97
  final subclaveEstado = int.parse(value.substring(0, 2));
  if (subclaveEstado < 1 || subclaveEstado > 97) {
    return 'El NSS contiene una subclave de estado inválida';
  }

  return null;
}
