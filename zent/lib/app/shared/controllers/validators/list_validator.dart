/// Valida que un valor esté contenido en una lista de valores permitidos
String? validateInList<T>(T? value, List<T> allowedValues,
    {String? fieldName, String? customMessage}) {
  if (value == null) {
    return 'El valor no puede ser nulo';
  }

  if (!allowedValues.contains(value)) {
    if (customMessage != null) {
      return customMessage;
    }

    final fieldText = fieldName ?? 'valor';

    // Si es una lista de strings, podemos mostrar las opciones permitidas
    if (allowedValues.isNotEmpty &&
        allowedValues.first is String &&
        allowedValues.length <= 10) {
      final options = allowedValues.join(', ');
      return 'El $fieldText seleccionado no es válido.';
    }

    return 'El $fieldText seleccionado no es válido';
  }

  return null;
}
