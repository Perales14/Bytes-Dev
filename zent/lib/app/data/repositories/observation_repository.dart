import '../models/base_model.dart';
import '../models/observation_model.dart';
import 'base_repository.dart';

class ObservationRepository extends BaseRepository<ObservationModel> {
  ObservationRepository() : super(tableName: 'observations');

  @override
  ObservationModel fromMap(Map<String, dynamic> map) {
    return ObservationModel(
      id: map['id'] ?? 0,
      sourceTable: map['source_table'] ?? '',
      sourceId: map['source_id'] ?? 0,
      observation: map['observation'] ?? '',
      userId: map['user_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
    );
  }

  @override
  Future<ObservationModel> update(ObservationModel model) async {
    try {
      if (model.id <= 0) {
        throw Exception('ID de observación inválido para actualización');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error al actualizar observación: $e');
    }
  }

  // Get observations by source
  Future<List<ObservationModel>> getBySource(
      String sourceTable, int sourceId) async {
    try {
      return await query(
          'source_table = ? AND source_id = ?', [sourceTable, sourceId]);
    } catch (e) {
      throw Exception('Error getting observations by source: $e');
    }
  }

  // Get observations by user
  Future<List<ObservationModel>> getByUser(int userId) async {
    try {
      return await query('user_id = ?', [userId]);
    } catch (e) {
      throw Exception('Error getting observations by user: $e');
    }
  }

  // Search observations by content
  Future<List<ObservationModel>> searchByContent(String text) async {
    try {
      return await query('observation LIKE ?', ['%$text%']);
    } catch (e) {
      throw Exception('Error searching observations by content: $e');
    }
  }

  // Get observations by source table
  Future<List<ObservationModel>> getBySourceTable(String sourceTable) async {
    try {
      return await query('source_table = ?', [sourceTable]);
    } catch (e) {
      throw Exception('Error getting observations by source table: $e');
    }
  }

  // Get recent observations
  Future<List<ObservationModel>> getRecentObservations(int limit) async {
    try {
      // Get all observations first
      final allObservations = await getAll();

      // Sort by created_at in descending order
      allObservations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Return only the requested number of records
      return allObservations.take(limit).toList();
    } catch (e) {
      throw Exception('Error getting recent observations: $e');
    }
  }
}
