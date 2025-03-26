import '../models/base_model.dart';
import '../models/provider_model.dart';
import 'base_repository.dart';

class ProviderRepository extends BaseRepository<ProviderModel> {
  ProviderRepository() : super(tableName: 'providers');

  @override
  ProviderModel fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      id: map['id'] ?? 0,
      specialtyId: map['specialty_id'] ?? 0,
      companyName: map['company_name'] ?? '',
      mainContactName: map['main_contact_name'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      taxIdentificationNumber: map['tax_identification_number'],
      serviceType: map['service_type'],
      paymentTerms: map['payment_terms'],
      addressId: map['address_id'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Find provider by email
  Future<ProviderModel?> findByEmail(String email) async {
    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding provider by email: $e');
    }
  }

  // Find provider by tax ID
  Future<ProviderModel?> findByTaxId(String taxId) async {
    try {
      final results = await query('tax_identification_number = ?', [taxId]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding provider by tax ID: $e');
    }
  }

  // Get providers by specialty
  Future<List<ProviderModel>> getBySpecialty(int specialtyId) async {
    try {
      return await query('specialty_id = ?', [specialtyId]);
    } catch (e) {
      throw Exception('Error getting providers by specialty: $e');
    }
  }

  // Get providers by service type
  Future<List<ProviderModel>> getByServiceType(String serviceType) async {
    try {
      return await query('service_type = ?', [serviceType]);
    } catch (e) {
      throw Exception('Error getting providers by service type: $e');
    }
  }

  // Find by company name
  Future<List<ProviderModel>> findByCompanyName(String companyName) async {
    try {
      return await query('company_name LIKE ?', ['%$companyName%']);
    } catch (e) {
      throw Exception('Error finding providers by company name: $e');
    }
  }

  // Get active providers
  Future<List<ProviderModel>> getActiveProviders() async {
    try {
      return await query('state_id = ?', [1]);
    } catch (e) {
      throw Exception('Error getting active providers: $e');
    }
  }

  // Search providers
  Future<List<ProviderModel>> searchProviders(String searchTerm) async {
    try {
      String term = '%$searchTerm%';
      return await query(
          'company_name LIKE ? OR main_contact_name LIKE ? OR email LIKE ? OR tax_identification_number LIKE ?',
          [term, term, term, term]);
    } catch (e) {
      throw Exception('Error searching providers: $e');
    }
  }

  // Create with validations
  @override
  Future<ProviderModel> create(ProviderModel model) async {
    try {
      // Check for duplicate email
      if (model.email != null && model.email!.isNotEmpty) {
        final existingProvider = await findByEmail(model.email!);
        if (existingProvider != null) {
          throw Exception('A provider with this email already exists');
        }
      }

      // Check for duplicate tax ID
      if (model.taxIdentificationNumber != null &&
          model.taxIdentificationNumber!.isNotEmpty) {
        final existingProvider =
            await findByTaxId(model.taxIdentificationNumber!);
        if (existingProvider != null) {
          throw Exception('A provider with this tax ID already exists');
        }
      }

      // Default state to active if not specified
      if (model.stateId <= 0) {
        model = model.copyWith(stateId: 1);
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating provider: $e');
    }
  }
}
