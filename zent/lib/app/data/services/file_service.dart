import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mime/mime.dart';
import '../models/file_model.dart';
import '../providers/file_provider.dart';

class FileService extends GetxService {
  final FileProvider _provider = FileProvider();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Basic CRUD operations
  Future<List<FileModel>> getAllFiles() => _provider.getAll();
  Future<FileModel?> getFileById(int id) => _provider.getById(id);
  Future<FileModel> createFile(FileModel file) => _provider.create(file);
  Future<FileModel> updateFile(FileModel file) => _provider.update(file);
  Future<void> deleteFile(int id) => _provider.delete(id);

  // Specific operations
  Future<List<FileModel>> getFilesByEntity(int entityId, String entityType) =>
      _provider.getFilesByEntity(entityId, entityType);
  Future<List<FileModel>> getFilesByType(String type) =>
      _provider.getFilesByType(type);
  Future<List<FileModel>> searchFilesByName(String searchTerm) =>
      _provider.searchByName(searchTerm);
  Future<List<FileModel>> getUnsentFiles() => _provider.getUnsent();
  Future<void> markFileAsSent(int id) => _provider.markAsSent(id);

  // Upload methods
  Future<FileModel> uploadFile({
    required File file,
    required int entityId,
    required String entityType,
    String? customName,
  }) async {
    try {
      final fileName = customName ?? path.basename(file.path);
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final fileSize = await file.length();

      // Generate storage path
      final storagePath =
          'entities/$entityType/$entityId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // Upload to Supabase Storage
      await _supabase.storage.from('files').upload(
            storagePath,
            file,
            fileOptions: FileOptions(contentType: mimeType),
          );

      // Get public URL
      final url = _supabase.storage.from('files').getPublicUrl(storagePath);

      // Create file data
      final fileData = {
        'name': fileName,
        'type': mimeType,
        'url': url,
        'storage_path': storagePath,
        'upload_date': DateTime.now().toIso8601String(),
        'entity_id': entityId,
        'entity_type': entityType,
        'size': fileSize,
        'sent': 0,
      };

      // Save to database
      return await _provider.saveFile(fileData);
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  // Delete file from storage and database
  Future<void> deleteFileCompletely(FileModel file) async {
    try {
      // Delete from storage
      await _supabase.storage.from('files').remove([file.storagePath]);

      // Delete from database
      await deleteFile(file.id);
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }

  // Business logic methods

  // Group files by type
  Map<String, List<FileModel>> groupFilesByType(List<FileModel> files) {
    final Map<String, List<FileModel>> result = {};

    for (final file in files) {
      if (!result.containsKey(file.type)) {
        result[file.type] = [];
      }
      result[file.type]!.add(file);
    }

    return result;
  }

  // Get total size of files
  int getTotalSize(List<FileModel> files) {
    return files.fold(0, (sum, file) => sum + (file.size ?? 0));
  }

  // Format total size for display
  String getFormattedTotalSize(List<FileModel> files) {
    final totalBytes = getTotalSize(files);

    if (totalBytes < 1024) return '$totalBytes B';
    if (totalBytes < 1024 * 1024) {
      return '${(totalBytes / 1024).toStringAsFixed(2)} KB';
    }
    if (totalBytes < 1024 * 1024 * 1024) {
      return '${(totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
