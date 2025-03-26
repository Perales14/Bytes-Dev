import '../models/base_model.dart';
import '../models/client_model.dart';
import 'base_repository.dart';

class ClientRepository extends BaseRepository<ClientModel> {
  ClientRepository() : super(tableName: 'clients');

  @override
  ClientModel fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      fatherLastName: map['father_last_name'] ?? '',
      motherLastName: map['mother_last_name'],
      companyName: map['company_name'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      taxIdentificationNumber: map['tax_identification_number'],
      clientType: map['client_type'],
      addressId: map['address_id'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Find client by email
  Future<ClientModel?> findByEmail(String email) async {
    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding client by email: $e');
    }
  }

  // Find client by tax identification number
  Future<ClientModel?> findByTaxId(String taxId) async {
    try {
      final results = await query('tax_identification_number = ?', [taxId]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding client by tax ID: $e');
    }
  }

  // Get clients by type
  Future<List<ClientModel>> getByType(String clientType) async {
    try {
      return await query('client_type = ?', [clientType]);
    } catch (e) {
      throw Exception('Error getting clients by type: $e');
    }
  }

  // Find by full name
  Future<List<ClientModel>> findByFullName(
      String name, String fatherLastName, String? motherLastName) async {
    try {
      if (motherLastName != null && motherLastName.isNotEmpty) {
        return await query(
            'name LIKE ? AND father_last_name LIKE ? AND mother_last_name LIKE ?',
            ['%$name%', '%$fatherLastName%', '%$motherLastName%']);
      } else {
        return await query('name LIKE ? AND father_last_name LIKE ?',
            ['%$name%', '%$fatherLastName%']);
      }
    } catch (e) {
      throw Exception('Error finding clients by full name: $e');
    }
  }

  // Find by company name
  Future<List<ClientModel>> findByCompanyName(String companyName) async {
    try {
      return await query('company_name LIKE ?', ['%$companyName%']);
    } catch (e) {
      throw Exception('Error finding clients by company name: $e');
    }
  }

  // Get active clients
  Future<List<ClientModel>> getActiveClients() async {
    try {
      return await query('state_id = ?', [1]);
    } catch (e) {
      throw Exception('Error getting active clients: $e');
    }
  }

  // Get clients by type and state
  Future<List<ClientModel>> getClientsByTypeAndState(
      String clientType, int stateId) async {
    try {
      return await query(
          'client_type = ? AND state_id = ?', [clientType, stateId]);
    } catch (e) {
      throw Exception('Error getting clients by type and state: $e');
    }
  }

  // General search
  Future<List<ClientModel>> searchClients(String searchTerm) async {
    try {
      String term = '%$searchTerm%';
      return await query(
          'name LIKE ? OR father_last_name LIKE ? OR company_name LIKE ? OR email LIKE ? OR tax_identification_number LIKE ?',
          [term, term, term, term, term]);
    } catch (e) {
      throw Exception('Error searching clients: $e');
    }
  }

  // Create with validations
  @override
  Future<ClientModel> create(ClientModel model) async {
    try {
      // Validate client type
      if (model.clientType != null &&
          !['Particular', 'Empresa', 'Gobierno'].contains(model.clientType)) {
        throw Exception('Invalid client type');
      }

      // Validate contact information
      if ((model.phoneNumber == null || model.phoneNumber!.isEmpty) &&
          (model.email == null || model.email!.isEmpty)) {
        throw Exception('Client must have either phone number or email');
      }

      // Validate company name for business clients
      if (model.clientType == 'Empresa' &&
          (model.companyName == null || model.companyName!.isEmpty)) {
        throw Exception('Business clients must have a company name');
      }

      // Check for duplicate email
      if (model.email != null && model.email!.isNotEmpty) {
        final existingClient = await findByEmail(model.email!);
        if (existingClient != null) {
          throw Exception('A client with this email already exists');
        }
      }

      // Check for duplicate tax ID
      if (model.taxIdentificationNumber != null &&
          model.taxIdentificationNumber!.isNotEmpty) {
        final existingClient =
            await findByTaxId(model.taxIdentificationNumber!);
        if (existingClient != null) {
          throw Exception('A client with this tax ID already exists');
        }
      }

      // Default state to active if not specified
      if (model.stateId <= 0) {
        model = model.copyWith(stateId: 1);
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating client: $e');
    }
  }
}
