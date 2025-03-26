import '../models/observation_model.dart';
import '../repositories/observation_repository.dart';

class ObservationProvider {
  final ObservationRepository _repository = ObservationRepository();

  // Basic CRUD operations
  Future<List<ObservationModel>> getAll() => _repository.getAll();
  Future<ObservationModel?> getById(int id) => _repository.getById(id);
  Future<ObservationModel> create(ObservationModel observation) =>
      _repository.create(observation);
  Future<ObservationModel> update(ObservationModel observation) =>
      _repository.update(observation);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<ObservationModel>> getBySource(
          String sourceTable, int sourceId) =>
      _repository.getBySource(sourceTable, sourceId);
  Future<List<ObservationModel>> getByUser(int userId) =>
      _repository.getByUser(userId);
  Future<List<ObservationModel>> searchByContent(String text) =>
      _repository.searchByContent(text);
  Future<List<ObservationModel>> getBySourceTable(String sourceTable) =>
      _repository.getBySourceTable(sourceTable);
  Future<List<ObservationModel>> getRecentObservations(int limit) =>
      _repository.getRecentObservations(limit);
}
