/// Valida que el texto no exceda la longitud máxima
String? validateMaxLength(String? value, int maxLength) {
  if (value != null && value.length > maxLength) {
    return 'No puede exceder $maxLength caracteres';
  }
  return null;
}

/// Valida que el texto cumpla con una longitud mínima
String? validateMinLength(String? value, int minLength) {
  if (value != null && value.isNotEmpty && value.length < minLength) {
    return 'Debe tener al menos $minLength caracteres';
  }
  return null;
}
