/// Valida que la contraseña cumpla con los requisitos mínimos de seguridad
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es requerida';
  }

  if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }

  return null;
}

/// Valida que la confirmación de contraseña coincida con la contraseña original
String? validatePasswordConfirmation(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'La confirmación de contraseña es requerida';
  }

  if (value != password) {
    return 'Las contraseñas no coinciden';
  }

  return null;
}
