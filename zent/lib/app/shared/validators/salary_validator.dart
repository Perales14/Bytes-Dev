/// Valida que el valor ingresado sea un salario válido
String? validateSalary(String? value) {
  if (value == null || value.isEmpty) {
    return 'El salario es requerido';
  }

  // Remover caracteres no numéricos excepto punto decimal
  final cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');

  // Verificar que sea un número válido
  double? salary;
  try {
    salary = double.parse(cleanValue);
  } catch (e) {
    return 'Ingrese un salario válido';
  }

  // Verificar que no sea negativo
  if (salary < 0) {
    return 'El salario no puede ser negativo';
  }

  return null;
}
