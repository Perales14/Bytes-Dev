/// Valida que la fecha tenga un formato válido
String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'La fecha es requerida';
  }

  try {
    final date = DateTime.parse(value);
    final now = DateTime.now();

    // Verificar que la fecha no sea futura
    if (date.isAfter(now)) {
      return 'La fecha no puede ser futura';
    }

    return null;
  } catch (e) {
    return 'Formato de fecha inválido';
  }
}
