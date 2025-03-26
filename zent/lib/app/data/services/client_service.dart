import 'package:get/get.dart';
import '../../data/models/client_model.dart';
import '../../data/providers/client_provider.dart';

class ClientService extends GetxService {
  final ClientProvider _provider = ClientProvider();

  // Basic CRUD operations
  Future<List<ClientModel>> getAllClients() => _provider.getAll();
  Future<ClientModel?> getClientById(int id) => _provider.getById(id);
  Future<ClientModel> createClient(ClientModel client) =>
      _provider.create(client);
  Future<ClientModel> updateClient(ClientModel client) =>
      _provider.update(client);
  Future<void> deleteClient(int id) => _provider.delete(id);

  // Search operations
  Future<List<ClientModel>> searchClients(String searchTerm) =>
      _provider.searchClients(searchTerm);
  Future<ClientModel?> findClientByEmail(String email) =>
      _provider.findByEmail(email);
  Future<ClientModel?> findClientByTaxId(String taxId) =>
      _provider.findByTaxId(taxId);
  Future<List<ClientModel>> findClientByFullName(
          String name, String fatherLastName, String? motherLastName) =>
      _provider.findByFullName(name, fatherLastName, motherLastName);
  Future<List<ClientModel>> findClientByCompanyName(String companyName) =>
      _provider.findByCompanyName(companyName);

  // Filtering operations
  Future<List<ClientModel>> getClientsByType(String clientType) =>
      _provider.getByType(clientType);
  Future<List<ClientModel>> getActiveClients() => _provider.getActiveClients();
  Future<List<ClientModel>> getClientsByTypeAndState(
          String clientType, int stateId) =>
      _provider.getClientsByTypeAndState(clientType, stateId);

  // Business logic methods
  bool isValidClientType(String? type) {
    return type != null && ['Particular', 'Empresa', 'Gobierno'].contains(type);
  }

  bool hasValidContactInfo(String? phone, String? email) {
    return (phone != null && phone.isNotEmpty) ||
        (email != null && email.isNotEmpty);
  }

  bool isValidForBusinessType(ClientModel client) {
    return client.clientType != 'Empresa' ||
        (client.companyName != null && client.companyName!.isNotEmpty);
  }
}
