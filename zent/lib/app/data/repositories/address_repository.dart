import 'package:zent/app/data/utils/database_helper.dart';

import '../models/base_model.dart';
import '../models/address_model.dart';
import 'base_repository.dart';

class AddressRepository extends BaseRepository<AddressModel> {
  AddressRepository() : super(tableName: 'addresses');

  @override
  AddressModel fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? 0,
      street: map['street'] ?? '',
      streetNumber: map['street_number'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      postalCode: map['postal_code'] ?? '',
      state: map['state'],
      country: map['country'],
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  @override
  Future<AddressModel> update(AddressModel model) async {
    try {
      if (model.id <= 0) {
        throw Exception('ID de dirección inválido para actualización');
      }

      model = model.copyWith(updatedAt: DateTime.now());

      final data = model.toUpdateMap();
      await DatabaseHelper.instance
          .update(tableName, data, 'id = ?', [model.id]);

      final updated = await getById(model.id);
      return updated ?? model;
    } catch (e) {
      throw Exception('Error al actualizar dirección: $e');
    }
  }

  // Find addresses by neighborhood
  Future<List<AddressModel>> findByNeighborhood(String neighborhood) async {
    try {
      return await query('neighborhood = ?', [neighborhood]);
    } catch (e) {
      throw Exception('Error finding addresses by neighborhood: $e');
    }
  }

  // Find addresses by postal code
  Future<List<AddressModel>> findByPostalCode(String postalCode) async {
    try {
      return await query('postal_code = ?', [postalCode]);
    } catch (e) {
      throw Exception('Error finding addresses by postal code: $e');
    }
  }

  // Find addresses by state
  Future<List<AddressModel>> findByState(String state) async {
    try {
      return await query('state = ?', [state]);
    } catch (e) {
      throw Exception('Error finding addresses by state: $e');
    }
  }

  // Find addresses by combined criteria
  Future<List<AddressModel>> findByCriteria(
      {String? street, String? neighborhood, String? postalCode}) async {
    try {
      List<String> conditions = [];
      List<dynamic> arguments = [];

      if (street != null && street.isNotEmpty) {
        conditions.add('street LIKE ?');
        arguments.add('%$street%');
      }

      if (neighborhood != null && neighborhood.isNotEmpty) {
        conditions.add('neighborhood LIKE ?');
        arguments.add('%$neighborhood%');
      }

      if (postalCode != null && postalCode.isNotEmpty) {
        conditions.add('postal_code = ?');
        arguments.add(postalCode);
      }

      if (conditions.isEmpty) {
        return await getAll();
      }

      String whereClause = conditions.join(' AND ');
      return await query(whereClause, arguments);
    } catch (e) {
      throw Exception('Error finding addresses by criteria: $e');
    }
  }

  // Search addresses
  Future<List<AddressModel>> searchAddresses(String searchTerm) async {
    try {
      String term = '%$searchTerm%';
      return await query(
          'street LIKE ? OR neighborhood LIKE ? OR postal_code LIKE ? OR state LIKE ?',
          [term, term, term, term]);
    } catch (e) {
      throw Exception('Error searching addresses: $e');
    }
  }
}
