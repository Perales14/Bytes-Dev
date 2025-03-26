import 'base_model.dart';

class ClientModel extends BaseModel {
  String name;
  String fatherLastName;
  String? motherLastName;
  String? companyName;
  String? phoneNumber;
  String? email;
  String? taxIdentificationNumber;
  String? clientType;
  int? addressId;
  int stateId;

  ClientModel({
    super.id = 0,
    required this.name,
    required this.fatherLastName,
    this.motherLastName,
    this.companyName,
    this.phoneNumber,
    this.email,
    this.taxIdentificationNumber,
    this.clientType,
    this.addressId,
    required this.stateId,
    super.createdAt,
    super.updatedAt,
  });

  // Full name getter
  String get fullName =>
      '$name $fatherLastName${motherLastName != null ? ' $motherLastName' : ''}';

  @override
  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'father_last_name': fatherLastName,
      'mother_last_name': motherLastName,
      'company_name': companyName,
      'phone_number': phoneNumber,
      'email': email,
      'tax_identification_number': taxIdentificationNumber,
      'client_type': clientType,
      'address_id': addressId,
      'state_id': stateId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
    if (id > 0) {
      map['id'] = id;
    }

    return map;
  }

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
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory ClientModel.fromJson(Map<String, dynamic> map) {
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
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  ClientModel copyWith({
    int? id,
    String? name,
    String? fatherLastName,
    String? motherLastName,
    String? companyName,
    String? phoneNumber,
    String? email,
    String? taxIdentificationNumber,
    String? clientType,
    int? addressId,
    int? stateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fatherLastName: fatherLastName ?? this.fatherLastName,
      motherLastName: motherLastName ?? this.motherLastName,
      companyName: companyName ?? this.companyName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      taxIdentificationNumber:
          taxIdentificationNumber ?? this.taxIdentificationNumber,
      clientType: clientType ?? this.clientType,
      addressId: addressId ?? this.addressId,
      stateId: stateId ?? this.stateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
