import 'base_model.dart';

class AddressModel extends BaseModel {
  String street;
  String streetNumber;
  String neighborhood;
  String postalCode;
  String? state;
  String? country;

  AddressModel({
    super.id = 0,
    required this.street,
    required this.streetNumber,
    required this.neighborhood,
    required this.postalCode,
    this.state,
    this.country,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'street_number': streetNumber,
      'neighborhood': neighborhood,
      'postal_code': postalCode,
      'state': state,
      'country': country,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

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
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? 0,
      street: map['street'] ?? '',
      streetNumber: map['street_number'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      postalCode: map['postal_code'] ?? '',
      state: map['state'],
      country: map['country'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  AddressModel copyWith({
    int? id,
    String? street,
    String? streetNumber,
    String? neighborhood,
    String? postalCode,
    String? state,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      street: street ?? this.street,
      streetNumber: streetNumber ?? this.streetNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      postalCode: postalCode ?? this.postalCode,
      state: state ?? this.state,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Formatted address for display
  String get fullAddress =>
      '$street $streetNumber, $neighborhood, $postalCode${state != null ? ', $state' : ''}${country != null ? ', $country' : ''}';
}
