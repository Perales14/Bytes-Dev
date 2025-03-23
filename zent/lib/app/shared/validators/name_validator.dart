/// Valida que el nombre contenga solo letras y espacios
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es requerido';
  }

  // Validar que solo contenga letras y espacios (incluyendo acentos y ñ)
  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$').hasMatch(value)) {
    return 'Solo debe contener letras y espacios';
  }

  return null;
}
