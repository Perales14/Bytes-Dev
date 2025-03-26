import 'dart:io';

/// Valida que el archivo tenga una extensión permitida
String? validateFileExtension(File file, List<String> allowedExtensions) {
  final extension = file.path.split('.').last.toLowerCase();
  if (!allowedExtensions.contains(extension)) {
    return 'Tipo de archivo no permitido. Extensiones permitidas: ${allowedExtensions.join(", ")}';
  }
  return null;
}

/// Valida que el archivo no exceda el tamaño máximo (en bytes)
String? validateFileSize(File file, int maxSizeBytes) {
  final sizeInBytes = file.lengthSync();
  if (sizeInBytes > maxSizeBytes) {
    final maxSizeMB = maxSizeBytes / (1024 * 1024);
    return 'El archivo excede el tamaño máximo permitido (${maxSizeMB.toStringAsFixed(2)} MB)';
  }
  return null;
}
