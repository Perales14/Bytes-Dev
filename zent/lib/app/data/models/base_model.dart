abstract class BaseModel {
  late int id;
  late DateTime createdAt;
  late DateTime updatedAt;
  BaseModel({
    this.id = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Method to be implemented in child classes to convert model to Map
  Map<String, dynamic> toMap();

  // Method to be implemented in child classes to create a model from Map
  BaseModel fromMap(Map<String, dynamic> map);

  // Method to serialize model to JSON (useful for debugging)
  Map<String, dynamic> toJson() => toMap();

  // Method to update the modification date
  void updateModifiedAt() {
    updatedAt = DateTime.now();
  }

  // Helper to convert dates from SQLite/Supabase
  static DateTime? parseDateTime(String? dateStr) {
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  // Helper to format dates for SQLite
  static String formatDateTime(DateTime date) {
    return date.toIso8601String();
  }
}
