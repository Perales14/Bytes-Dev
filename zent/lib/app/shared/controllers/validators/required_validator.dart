/// Valida que el campo no esté vacío
String? validateRequired(String? value, {String? fieldName}) {
  if (value == null || value.isEmpty) {
    return fieldName != null
        ? 'El campo $fieldName es requerido'
        : 'Este campo es requerido';
  }
  return null;
}
