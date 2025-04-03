import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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

  Future<List<FileModel>> getFilesByEmployeeId(int employeeId) async {
    try {
      // Llamada específica para obtener archivos de empleado
      return await _provider.getFilesByEntity(employeeId, 'employee');
    } catch (e) {
      print('Error al obtener archivos del empleado $employeeId: $e');
      return [];
    }
  }

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

  Future<bool> uploadFileWithFilePicker({
    required int entityId,
    required String entityType,
    required Function onFileSelected,
  }) async {
    try {
      // Implementar la selección de archivo con file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return false; // El usuario canceló la selección
      }

      // Notificar que se ha seleccionado un archivo
      onFileSelected();

      final platformFile = result.files.first;

      if (kIsWeb) {
        // Para web, implementar la subida desde bytes
        if (platformFile.bytes == null) return false;

        final fileName = platformFile.name;
        final mimeType = platformFile.extension != null
            ? lookupMimeType('file.${platformFile.extension}') ??
                'application/octet-stream'
            : 'application/octet-stream';

        // Generate storage path
        final storagePath =
            'entities/$entityType/$entityId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

        // Upload to Supabase Storage
        await _supabase.storage.from('files').uploadBinary(
              storagePath,
              platformFile.bytes!,
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
          'size': platformFile.size,
          'sent': 0,
        };

        // Save to database
        await _provider.saveFile(fileData);
        return true;
      } else {
        // Para dispositivos móviles, implementar la subida desde archivo
        if (platformFile.path == null) return false;

        final file = File(platformFile.path!);
        await uploadFile(
          file: file,
          entityId: entityId,
          entityType: entityType,
        );
        return true;
      }
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Error uploading file: $e');
    }
  }

  void prueba(FileModel file) async {
    // final a = await _supabase.storage
    //     .from('employee-files')
    //     .remove(['0_1743061226157_Link de archivos.txt']);
    // // print('Buckets: ${a.last.name}');
    // for (final bucket in a) {
    //   print('Bucket: ${bucket.name}');
    // }
    final parts = file.storagePath.split('/');
    // Asegurarnos que el storage path esté bien formateado
    // final storagePath = file.storagePath.startsWith('/')
    //     ? file.storagePath.substring(1)
    //     : file.storagePath;
    final bucket = parts[0];
    final storageName = parts[1];

    print('Bucket: $bucket, Storage Name: $storageName');
  }

  // Delete file from storage and database
  Future<void> deleteFileCompletely(FileModel file) async {
    try {
      print('Eliminando archivo de storage: ${file.storagePath}');
      final parts = file.storagePath.split('/');
      final bucket = parts[0];
      final storageName = parts[1];

      print('Bucket: $bucket, Storage Name: $storageName');

      // Eliminar primero del storage
      await _supabase.storage.from(bucket).remove([storageName]);
      print('Archivo eliminado del storage');

      // Luego eliminar de la base de datos
      await deleteFile(file.id);
      print('Archivo eliminado de la base de datos');
    } catch (e) {
      print('Error al eliminar archivo completamente: $e');
      // Intentar eliminar al menos de la base de datos si falla el storage
      try {
        await deleteFile(file.id);
        throw Exception(
            'El archivo se eliminó de la base de datos, pero no del almacenamiento: $e');
      } catch (dbError) {
        throw Exception(
            'Error eliminando archivo: $e, Error adicional: $dbError');
      }
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
