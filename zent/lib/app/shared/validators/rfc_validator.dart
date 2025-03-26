/// Valida que el RFC tenga el formato correcto para personas físicas en México
String? validateRFC(String? value) {
  if (value == null || value.isEmpty) {
    return 'El RFC es requerido';
  }

  // Validar longitud (13 caracteres para personas físicas)
  if (value.length != 13) {
    return 'El RFC debe tener 13 caracteres';
  }

  // Expresión regular para validar la estructura de RFC para personas físicas:
  // 4 letras + 6 dígitos + 3 caracteres alfanuméricos
  final RegExp rfcRegExp =
      RegExp(r'^[A-Z]{4}\d{6}[A-Z0-9]{3}$', caseSensitive: true);

  if (!rfcRegExp.hasMatch(value)) {
    return 'El RFC debe tener el formato: XXXX000000XXX';
  }

  // Extraer los componentes de la fecha
  int year, month, day;

  try {
    year = int.parse(value.substring(4, 6));
    month = int.parse(value.substring(6, 8));
    day = int.parse(value.substring(8, 10));
  } catch (e) {
    return 'El RFC contiene una fecha inválida';
  }

  // Ajustar el año (asumimos que años 30+ son del siglo XX, y el resto del siglo XXI)
  final fullYear = year >= 30 ? 1900 + year : 2000 + year;

  // Verificar que la fecha es válida
  if (month < 1 || month > 12) {
    return 'El RFC contiene un mes inválido';
  }

  // Validar días según el mes
  final daysInMonth = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (day < 1 || day > daysInMonth[month]) {
    return 'El RFC contiene un día inválido';
  }

  return null;
}
