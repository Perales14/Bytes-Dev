import 'package:zent/data/models/direccion_model.dart';

abstract class IDireccionRepository {
  Future<List<Direccion>> getAll({bool forceRefresh = false});
  Future<Direccion?> getById(int id);
  Future<int> save(Direccion direccion);
  Future<bool> update(Direccion direccion);
  Future<bool> delete(int id);
  Future<void> syncPendingToRemote();
}
