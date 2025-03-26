abstract class BaseModel {
  late int id;
  late DateTime createdAt;
  late DateTime updatedAt;
  bool enviado;

  BaseModel({
    this.id = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Método a implementar en las clases hijas para convertir el modelo a un Map
  Map<String, dynamic> toMap();

  // Método a implementar en las clases hijas para crear un modelo desde un Map
  BaseModel fromMap(Map<String, dynamic> map);

  // Método para serializar el modelo a JSON (útil para depuración)
  Map<String, dynamic> toJson() => toMap();

  // Método para verificar si el modelo ya está sincronizado
  bool get isSynced => enviado;

  // Método para marcar como sincronizado
  void markAsSynced() {
    enviado = true;
  }

  // Método para marcar como no sincronizado (para cambios locales)
  void markAsNotSynced() {
    enviado = false;
  }

  // Método para actualizar la fecha de modificación
  void updateModifiedAt() {
    updatedAt = DateTime.now();
  }

  // Helper para convertir fechas de SQLite/Supabase
  static DateTime? parseDateTime(String? dateStr) {
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  // Helper para formatear fechas para SQLite
  static String formatDateTime(DateTime date) {
    return date.toIso8601String();
  }
}
