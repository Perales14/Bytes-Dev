import 'package:get/get.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';

class AddressService extends GetxService {
  final AddressProvider _provider = AddressProvider();

  // Basic CRUD operations
  Future<List<AddressModel>> getAllAddresses() => _provider.getAll();
  Future<AddressModel?> getAddressById(int id) => _provider.getById(id);
  Future<AddressModel> createAddress(AddressModel address) =>
      _provider.create(address);
  Future<AddressModel> updateAddress(AddressModel address) =>
      _provider.update(address);
  Future<void> deleteAddress(int id) => _provider.delete(id);

  // Search operations
  Future<List<AddressModel>> searchAddresses(String searchTerm) =>
      _provider.searchAddresses(searchTerm);
  Future<List<AddressModel>> findAddressesByNeighborhood(String neighborhood) =>
      _provider.findByNeighborhood(neighborhood);
  Future<List<AddressModel>> findAddressesByPostalCode(String postalCode) =>
      _provider.findByPostalCode(postalCode);
  Future<List<AddressModel>> findAddressesByState(String state) =>
      _provider.findByState(state);

  // Combined search
  Future<List<AddressModel>> findAddressesByCriteria(
          {String? street, String? neighborhood, String? postalCode}) =>
      _provider.findByCriteria(
          street: street, neighborhood: neighborhood, postalCode: postalCode);

  // Business logic methods
  bool isValidPostalCode(String postalCode) {
    // Validar formato de código postal según el país
    // Ejemplo simple para México: 5 dígitos
    return postalCode.length == 5 && RegExp(r'^\d{5}$').hasMatch(postalCode);
  }

  // Formato para mostrar dirección completa
  String getFormattedAddress(AddressModel address) {
    return address.fullAddress;
  }
}
