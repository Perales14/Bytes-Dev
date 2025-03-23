/// Valida que se haya seleccionado un elemento de una lista desplegable
String? validateSelection(String? value, {String fieldName = 'elemento'}) {
  if (value == null || value.isEmpty) {
    return 'Debe seleccionar un $fieldName';
  }
  return null;
}
