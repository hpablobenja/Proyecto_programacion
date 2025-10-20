import '../../domain/entities/employee.dart';

class EmployeeModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;
  final int? storeId;
  final int? warehouseId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.storeId,
    this.warehouseId,
    required this.createdAt,
    this.updatedAt,
  });

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      role: employee.role,
      phone: employee.phone,
      address: employee.address,
      storeId: employee.storeId,
      warehouseId: employee.warehouseId,
      createdAt: employee.createdAt,
      updatedAt: employee.updatedAt,
    );
  }

  Employee toEntity() {
    return Employee(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      address: address,
      storeId: storeId,
      warehouseId: warehouseId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
      'store_id': storeId,
      'warehouse_id': warehouseId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      storeId: json['store_id'] as int?,
      warehouseId: json['warehouse_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
