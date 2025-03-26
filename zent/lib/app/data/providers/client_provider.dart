import '../models/client_model.dart';
import '../repositories/client_repository.dart';

class ClientProvider {
  final ClientRepository _repository = ClientRepository();

  // Basic CRUD operations
  Future<List<ClientModel>> getAll() => _repository.getAll();
  Future<ClientModel?> getById(int id) => _repository.getById(id);
  Future<ClientModel> create(ClientModel client) => _repository.create(client);
  Future<ClientModel> update(ClientModel client) => _repository.update(client);
  Future<void> delete(int id) => _repository.delete(id);

  // Search operations
  Future<List<ClientModel>> searchClients(String searchTerm) =>
      _repository.searchClients(searchTerm);
  Future<ClientModel?> findByEmail(String email) =>
      _repository.findByEmail(email);
  Future<ClientModel?> findByTaxId(String taxId) =>
      _repository.findByTaxId(taxId);
  Future<List<ClientModel>> findByFullName(
          String name, String fatherLastName, String? motherLastName) =>
      _repository.findByFullName(name, fatherLastName, motherLastName);
  Future<List<ClientModel>> findByCompanyName(String companyName) =>
      _repository.findByCompanyName(companyName);

  // Filtering operations
  Future<List<ClientModel>> getByType(String clientType) =>
      _repository.getByType(clientType);
  Future<List<ClientModel>> getActiveClients() =>
      _repository.getActiveClients();
  Future<List<ClientModel>> getClientsByTypeAndState(
          String clientType, int stateId) =>
      _repository.getClientsByTypeAndState(clientType, stateId);
}
