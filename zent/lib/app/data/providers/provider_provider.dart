import '../models/provider_model.dart';
import '../repositories/provider_repository.dart';

class ProviderProvider {
  final ProviderRepository _repository = ProviderRepository();

  // Basic CRUD operations
  Future<List<ProviderModel>> getAll() => _repository.getAll();
  Future<ProviderModel?> getById(int id) => _repository.getById(id);
  Future<ProviderModel> create(ProviderModel provider) =>
      _repository.create(provider);
  Future<ProviderModel> update(ProviderModel provider) =>
      _repository.update(provider);
  Future<void> delete(int id) => _repository.delete(id);

  // Search operations
  Future<List<ProviderModel>> searchProviders(String searchTerm) =>
      _repository.searchProviders(searchTerm);
  Future<ProviderModel?> findByEmail(String email) =>
      _repository.findByEmail(email);
  Future<ProviderModel?> findByTaxId(String taxId) =>
      _repository.findByTaxId(taxId);
  Future<List<ProviderModel>> findByCompanyName(String companyName) =>
      _repository.findByCompanyName(companyName);

  // Filtering operations
  Future<List<ProviderModel>> getBySpecialty(int specialtyId) =>
      _repository.getBySpecialty(specialtyId);
  Future<List<ProviderModel>> getByServiceType(String serviceType) =>
      _repository.getByServiceType(serviceType);
  Future<List<ProviderModel>> getActiveProviders() =>
      _repository.getActiveProviders();
}
