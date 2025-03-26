import 'base_model.dart';

class UserModel extends BaseModel {
  int roleId;
  int? specialtyId;
  String name;
  String fatherLastName;
  String? motherLastName;
  String email;
  String? phoneNumber;
  String socialSecurityNumber;
  String passwordHash;
  DateTime entryDate;
  double? salary;
  String? contractType;
  int? supervisorId;
  String? department;
  int stateId;

  UserModel({
    super.id = 0,
    required this.roleId,
    this.specialtyId,
    required this.name,
    required this.fatherLastName,
    this.motherLastName,
    required this.email,
    this.phoneNumber,
    required this.socialSecurityNumber,
    required this.passwordHash,
    required this.entryDate,
    this.salary,
    this.contractType,
    this.supervisorId,
    this.department,
    required this.stateId,
    super.createdAt,
    super.updatedAt,
  });

  // Computed property to get full name
  String get fullName =>
      '$name $fatherLastName${motherLastName != null ? ' $motherLastName' : ''}';

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role_id': roleId,
      'specialty_id': specialtyId,
      'name': name,
      'father_last_name': fatherLastName,
      'mother_last_name': motherLastName,
      'email': email,
      'phone_number': phoneNumber,
      'social_security_number': socialSecurityNumber,
      'password_hash': passwordHash,
      'entry_date': BaseModel.formatDateTime(entryDate),
      'salary': salary,
      'contract_type': contractType,
      'supervisor_id': supervisorId,
      'department': department,
      'state_id': stateId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      roleId: map['role_id'] ?? 0,
      specialtyId: map['specialty_id'],
      name: map['name'] ?? '',
      fatherLastName: map['father_last_name'] ?? '',
      motherLastName: map['mother_last_name'],
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'],
      socialSecurityNumber: map['social_security_number'] ?? '',
      passwordHash: map['password_hash'] ?? '',
      entryDate: BaseModel.parseDateTime(map['entry_date']) ?? DateTime.now(),
      salary: map['salary'] != null
          ? (map['salary'] is double
              ? map['salary']
              : double.parse(map['salary'].toString()))
          : null,
      contractType: map['contract_type'],
      supervisorId: map['supervisor_id'],
      department: map['department'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  // Factory constructor to create from Map
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      roleId: map['role_id'] ?? 0,
      specialtyId: map['specialty_id'],
      name: map['name'] ?? '',
      fatherLastName: map['father_last_name'] ?? '',
      motherLastName: map['mother_last_name'],
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'],
      socialSecurityNumber: map['social_security_number'] ?? '',
      passwordHash: map['password_hash'] ?? '',
      entryDate: BaseModel.parseDateTime(map['entry_date']) ?? DateTime.now(),
      salary: map['salary'] != null
          ? (map['salary'] is double
              ? map['salary']
              : double.parse(map['salary'].toString()))
          : null,
      contractType: map['contract_type'],
      supervisorId: map['supervisor_id'],
      department: map['department'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  // Method to clone the object with modifications
  UserModel copyWith({
    int? id,
    int? roleId,
    int? specialtyId,
    String? name,
    String? fatherLastName,
    String? motherLastName,
    String? email,
    String? phoneNumber,
    String? socialSecurityNumber,
    String? passwordHash,
    DateTime? entryDate,
    double? salary,
    String? contractType,
    int? supervisorId,
    String? department,
    int? stateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      specialtyId: specialtyId ?? this.specialtyId,
      name: name ?? this.name,
      fatherLastName: fatherLastName ?? this.fatherLastName,
      motherLastName: motherLastName ?? this.motherLastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
      passwordHash: passwordHash ?? this.passwordHash,
      entryDate: entryDate ?? this.entryDate,
      salary: salary ?? this.salary,
      contractType: contractType ?? this.contractType,
      supervisorId: supervisorId ?? this.supervisorId,
      department: department ?? this.department,
      stateId: stateId ?? this.stateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
