/// Valida que la dirección no contenga caracteres especiales no permitidos
String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'La dirección es requerida';
  }

  // Validar que no contenga caracteres especiales no deseados
  if (RegExp(r'[<>{}[\]\/]').hasMatch(value)) {
    return 'La dirección contiene caracteres no permitidos';
  }

  return null;
}
