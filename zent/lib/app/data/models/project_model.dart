import 'base_model.dart';

class ProjectModel extends BaseModel {
  String name;
  String? description;
  int clientId;
  int managerId;
  int? providerId;
  DateTime? startDate;
  DateTime? estimatedEndDate;
  DateTime? actualEndDate;
  DateTime? deliveryDate;
  double? estimatedBudget;
  double? actualCost;
  double? commissionPercentage;
  int? addressId;
  int stateId;

  ProjectModel({
    super.id = 0,
    required this.name,
    this.description,
    required this.clientId,
    required this.managerId,
    this.providerId,
    this.startDate,
    this.estimatedEndDate,
    this.actualEndDate,
    this.deliveryDate,
    this.estimatedBudget,
    this.actualCost,
    this.commissionPercentage,
    this.addressId,
    required this.stateId,
    super.createdAt,
    super.updatedAt,
  });

  // Compute consulting commission (should mirror DB calculation)
  double? get consultingCommission {
    if (actualCost != null && commissionPercentage != null) {
      return (actualCost! * commissionPercentage!) / 100;
    }
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'client_id': clientId,
      'manager_id': managerId,
      'provider_id': providerId,
      'start_date':
          startDate != null ? BaseModel.formatDateTime(startDate!) : null,
      'estimated_end_date': estimatedEndDate != null
          ? BaseModel.formatDateTime(estimatedEndDate!)
          : null,
      'actual_end_date': actualEndDate != null
          ? BaseModel.formatDateTime(actualEndDate!)
          : null,
      'delivery_date':
          deliveryDate != null ? BaseModel.formatDateTime(deliveryDate!) : null,
      'estimated_budget': estimatedBudget,
      'actual_cost': actualCost,
      'commission_percentage': commissionPercentage,
      'address_id': addressId,
      'state_id': stateId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  ProjectModel fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      clientId: map['client_id'] ?? 0,
      managerId: map['manager_id'] ?? 0,
      providerId: map['provider_id'],
      startDate: BaseModel.parseDateTime(map['start_date']),
      estimatedEndDate: BaseModel.parseDateTime(map['estimated_end_date']),
      actualEndDate: BaseModel.parseDateTime(map['actual_end_date']),
      deliveryDate: BaseModel.parseDateTime(map['delivery_date']),
      estimatedBudget: map['estimated_budget'] != null
          ? double.tryParse(map['estimated_budget'].toString())
          : null,
      actualCost: map['actual_cost'] != null
          ? double.tryParse(map['actual_cost'].toString())
          : null,
      commissionPercentage: map['commission_percentage'] != null
          ? double.tryParse(map['commission_percentage'].toString())
          : null,
      addressId: map['address_id'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      clientId: map['client_id'] ?? 0,
      managerId: map['manager_id'] ?? 0,
      providerId: map['provider_id'],
      startDate: BaseModel.parseDateTime(map['start_date']),
      estimatedEndDate: BaseModel.parseDateTime(map['estimated_end_date']),
      actualEndDate: BaseModel.parseDateTime(map['actual_end_date']),
      deliveryDate: BaseModel.parseDateTime(map['delivery_date']),
      estimatedBudget: map['estimated_budget'] != null
          ? double.tryParse(map['estimated_budget'].toString())
          : null,
      actualCost: map['actual_cost'] != null
          ? double.tryParse(map['actual_cost'].toString())
          : null,
      commissionPercentage: map['commission_percentage'] != null
          ? double.tryParse(map['commission_percentage'].toString())
          : null,
      addressId: map['address_id'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  ProjectModel copyWith({
    int? id,
    String? name,
    String? description,
    int? clientId,
    int? managerId,
    int? providerId,
    DateTime? startDate,
    DateTime? estimatedEndDate,
    DateTime? actualEndDate,
    DateTime? deliveryDate,
    double? estimatedBudget,
    double? actualCost,
    double? commissionPercentage,
    int? addressId,
    int? stateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      managerId: managerId ?? this.managerId,
      providerId: providerId ?? this.providerId,
      startDate: startDate ?? this.startDate,
      estimatedEndDate: estimatedEndDate ?? this.estimatedEndDate,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      actualCost: actualCost ?? this.actualCost,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      addressId: addressId ?? this.addressId,
      stateId: stateId ?? this.stateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
