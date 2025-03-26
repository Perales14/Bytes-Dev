import 'package:get/get.dart';
import '../models/provider_model.dart';
import '../providers/provider_provider.dart';

class ProviderService extends GetxService {
  final ProviderProvider _provider = ProviderProvider();

  // Basic CRUD operations
  Future<List<ProviderModel>> getAllProviders() => _provider.getAll();
  Future<ProviderModel?> getProviderById(int id) => _provider.getById(id);
  Future<ProviderModel> createProvider(ProviderModel provider) =>
      _provider.create(provider);
  Future<ProviderModel> updateProvider(ProviderModel provider) =>
      _provider.update(provider);
  Future<void> deleteProvider(int id) => _provider.delete(id);

  // Search operations
  Future<List<ProviderModel>> searchProviders(String searchTerm) =>
      _provider.searchProviders(searchTerm);
  Future<ProviderModel?> findProviderByEmail(String email) =>
      _provider.findByEmail(email);
  Future<ProviderModel?> findProviderByTaxId(String taxId) =>
      _provider.findByTaxId(taxId);
  Future<List<ProviderModel>> findProviderByCompanyName(String companyName) =>
      _provider.findByCompanyName(companyName);

  // Filtering operations
  Future<List<ProviderModel>> getProvidersBySpecialty(int specialtyId) =>
      _provider.getBySpecialty(specialtyId);
  Future<List<ProviderModel>> getProvidersByServiceType(String serviceType) =>
      _provider.getByServiceType(serviceType);
  Future<List<ProviderModel>> getActiveProviders() =>
      _provider.getActiveProviders();

  // Business logic methods
  bool hasValidContactInfo(ProviderModel provider) {
    return (provider.phoneNumber != null && provider.phoneNumber!.isNotEmpty) ||
        (provider.email != null && provider.email!.isNotEmpty);
  }

  bool hasValidIdentification(ProviderModel provider) {
    return provider.taxIdentificationNumber != null &&
        provider.taxIdentificationNumber!.isNotEmpty;
  }
}
