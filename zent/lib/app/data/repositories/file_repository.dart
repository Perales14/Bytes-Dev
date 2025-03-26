// app/data/repositories/file_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
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
      uploadDate: DateTime.parse(map['upload_date']),
      entityId: map['entity_id'],
      entityType: map['entity_type'] ?? '',
      size: map['size'],
    );
  }

  Future<List<FileModel>> getFilesByEntity(
      int entityId, String entityType) async {
    try {
      final results = await query(
          'entity_id = ? AND entity_type = ?', [entityId, entityType]);
      // final results = await db!.query(
      //   tableName,
      //   where: 'entity_id = ? AND entity_type = ?',
      //   whereArgs: [entityId, entityType],
      // );

      // return results.map((map) => fromMap(map)).toList();
      return results;
    } catch (e) {
      throw Exception('Error al obtener archivos: $e');
    }
  }

  Map<String, dynamic> toMap(FileModel model) {
    return {
      'id': model.id,
      'name': model.name,
      'type': model.type,
      'url': model.url,
      'storage_path': model.storagePath,
      'upload_date': model.uploadDate.toIso8601String(),
      'entity_id': model.entityId,
      'entity_type': model.entityType,
      'size': model.size,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
      'enviado': model.enviado ? 1 : 0,
    };
  }

  // Añade este método a tu clase FileRepository
  Future<FileModel> saveFile(Map<String, dynamic> fileData) async {
    try {
      // Convertir el mapa a un modelo FileModel
      final FileModel fileModel = FileModel(
        name: fileData['name'] ?? '',
        type: fileData['type'] ?? '',
        url: fileData['url'] ?? '',
        storagePath: fileData['storage_path'] ?? '',
        uploadDate: DateTime.parse(fileData['upload_date']),
        entityId: fileData['entity_id'] ?? 0,
        entityType: fileData['entity_type'] ?? '',
        size: fileData['size'],
      );

      // Usar el método create del repositorio base para guardar el archivo
      return await create(fileModel);
    } catch (e) {
      print('Error al guardar archivo: $e');
      throw Exception('Error al guardar archivo: $e');
    }
  }
}
