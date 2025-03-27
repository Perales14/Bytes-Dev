import 'base_model.dart';

class ProviderModel extends BaseModel {
  int specialtyId;
  String companyName;
  String? mainContactName;
  String? phoneNumber;
  String? email;
  String? taxIdentificationNumber;
  String? serviceType;
  String? paymentTerms;
  int? addressId;
  int stateId;

  ProviderModel({
    super.id = 0,
    required this.specialtyId,
    required this.companyName,
    this.mainContactName,
    this.phoneNumber,
    this.email,
    this.taxIdentificationNumber,
    this.serviceType,
    this.paymentTerms,
    this.addressId,
    required this.stateId,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = {
      'specialty_id': specialtyId,
      'company_name': companyName,
      'main_contact_name': mainContactName,
      'phone_number': phoneNumber,
      'email': email,
      'tax_identification_number': taxIdentificationNumber,
      'service_type': serviceType,
      'payment_terms': paymentTerms,
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
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory ProviderModel.fromJson(Map<String, dynamic> map) {
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
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  ProviderModel copyWith({
    int? id,
    int? specialtyId,
    String? companyName,
    String? mainContactName,
    String? phoneNumber,
    String? email,
    String? taxIdentificationNumber,
    String? serviceType,
    String? paymentTerms,
    int? addressId,
    int? stateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProviderModel(
      id: id ?? this.id,
      specialtyId: specialtyId ?? this.specialtyId,
      companyName: companyName ?? this.companyName,
      mainContactName: mainContactName ?? this.mainContactName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      taxIdentificationNumber:
          taxIdentificationNumber ?? this.taxIdentificationNumber,
      serviceType: serviceType ?? this.serviceType,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      addressId: addressId ?? this.addressId,
      stateId: stateId ?? this.stateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
