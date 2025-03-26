// app/data/repositories/file_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/base_model.dart';
import '../models/file_model.dart';
import 'base_repository.dart';

class FileRepository extends BaseRepository<FileModel> {
  FileRepository() : super(tableName: 'files');

  @override
  FileModel fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      storagePath: map['storage_path'] ?? '',
      uploadDate: BaseModel.parseDateTime(map['upload_date']) ?? DateTime.now(),
      entityId: map['entity_id'] ?? 0,
      entityType: map['entity_type'] ?? '',
      size: map['size'],
      sent: map['sent'] == 1,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get files by entity
  Future<List<FileModel>> getFilesByEntity(
      int entityId, String entityType) async {
    try {
      return await query(
          'entity_id = ? AND entity_type = ?', [entityId, entityType]);
    } catch (e) {
      throw Exception('Error getting files by entity: $e');
    }
  }

  // Get files by type
  Future<List<FileModel>> getFilesByType(String type) async {
    try {
      return await query('type = ?', [type]);
    } catch (e) {
      throw Exception('Error getting files by type: $e');
    }
  }

  // Search files by name
  Future<List<FileModel>> searchByName(String searchTerm) async {
    try {
      return await query('name LIKE ?', ['%$searchTerm%']);
    } catch (e) {
      throw Exception('Error searching files by name: $e');
    }
  }

  // Save file from map data
  Future<FileModel> saveFile(Map<String, dynamic> fileData) async {
    try {
      final FileModel fileModel = FileModel(
        name: fileData['name'] ?? '',
        type: fileData['type'] ?? '',
        url: fileData['url'] ?? '',
        storagePath: fileData['storage_path'] ?? '',
        uploadDate:
            BaseModel.parseDateTime(fileData['upload_date']) ?? DateTime.now(),
        entityId: fileData['entity_id'] ?? 0,
        entityType: fileData['entity_type'] ?? '',
        size: fileData['size'],
        sent: fileData['sent'] == 1,
      );

      return await create(fileModel);
    } catch (e) {
      throw Exception('Error saving file: $e');
    }
  }

  // Get unsent files
  @override
  Future<List<FileModel>> getUnsent() async {
    try {
      return await query('sent = ?', [0]);
    } catch (e) {
      throw Exception('Error getting unsent files: $e');
    }
  }

  // Mark file as sent
  @override
  Future<void> markAsSent(int id) async {
    try {
      // Use update method from BaseRepository instead of directly accessing _dbHelper
      FileModel? file = await getById(id);
      if (file != null) {
        file = file.copyWith(sent: true);
        await update(file);
      }
    } catch (e) {
      throw Exception('Error marking file as sent: $e');
    }
  }
}
