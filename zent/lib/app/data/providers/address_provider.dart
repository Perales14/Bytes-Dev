import '../models/address_model.dart';
import '../repositories/address_repository.dart';

class AddressProvider {
  final AddressRepository _repository = AddressRepository();

  // Basic CRUD operations
  Future<List<AddressModel>> getAll() => _repository.getAll();
  Future<AddressModel?> getById(int id) => _repository.getById(id);
  Future<AddressModel> create(AddressModel address) =>
      _repository.create(address);
  Future<AddressModel> update(AddressModel address) =>
      _repository.update(address);
  Future<void> delete(int id) => _repository.delete(id);

  // Search operations
  Future<List<AddressModel>> searchAddresses(String searchTerm) =>
      _repository.searchAddresses(searchTerm);
  Future<List<AddressModel>> findByNeighborhood(String neighborhood) =>
      _repository.findByNeighborhood(neighborhood);
  Future<List<AddressModel>> findByPostalCode(String postalCode) =>
      _repository.findByPostalCode(postalCode);
  Future<List<AddressModel>> findByState(String state) =>
      _repository.findByState(state);

  // Combined search
  Future<List<AddressModel>> findByCriteria(
          {String? street, String? neighborhood, String? postalCode}) =>
      _repository.findByCriteria(
          street: street, neighborhood: neighborhood, postalCode: postalCode);
}
