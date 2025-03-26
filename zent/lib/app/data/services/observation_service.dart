import 'package:get/get.dart';
import '../models/observation_model.dart';
import '../providers/observation_provider.dart';

class ObservationService extends GetxService {
  final ObservationProvider _provider = ObservationProvider();

  // Basic CRUD operations
  Future<List<ObservationModel>> getAllObservations() => _provider.getAll();
  Future<ObservationModel?> getObservationById(int id) => _provider.getById(id);
  Future<ObservationModel> createObservation(ObservationModel observation) =>
      _provider.create(observation);
  Future<ObservationModel> updateObservation(ObservationModel observation) =>
      _provider.update(observation);
  Future<void> deleteObservation(int id) => _provider.delete(id);

  // Specific operations
  Future<List<ObservationModel>> getObservationsBySource(
          String sourceTable, int sourceId) =>
      _provider.getBySource(sourceTable, sourceId);
  Future<List<ObservationModel>> getObservationsByUser(int userId) =>
      _provider.getByUser(userId);
  Future<List<ObservationModel>> searchObservationsByContent(String text) =>
      _provider.searchByContent(text);
  Future<List<ObservationModel>> getObservationsBySourceTable(
          String sourceTable) =>
      _provider.getBySourceTable(sourceTable);
  Future<List<ObservationModel>> getRecentObservations({int limit = 10}) =>
      _provider.getRecentObservations(limit);

  // Business logic methods

  // Add a quick observation helper
  Future<ObservationModel> addQuickObservation({
    required String sourceTable,
    required int sourceId,
    required String text,
    required int userId,
  }) async {
    final observation = ObservationModel(
      sourceTable: sourceTable,
      sourceId: sourceId,
      observation: text,
      userId: userId,
    );

    return await createObservation(observation);
  }

  // Get formatted date for display
  String getFormattedCreationDate(ObservationModel observation) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = observation.createdAt;

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return '${date.day}/${date.month}/${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Get observations count for a source
  Future<int> getObservationsCount(String sourceTable, int sourceId) async {
    final observations = await getObservationsBySource(sourceTable, sourceId);
    return observations.length;
  }
}
