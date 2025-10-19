import '../../domain/entities/employee.dart';

class EmployeeModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? storeId;
  final int? warehouseId;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.storeId,
    this.warehouseId,
  });

  factory EmployeeModel.fromEntity(Employee entity) {
    return EmployeeModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      storeId: entity.storeId,
      warehouseId: entity.warehouseId,
    );
  }

  Employee toEntity() {
    return Employee(
      id: id,
      name: name,
      email: email,
      role: role,
      storeId: storeId,
      warehouseId: warehouseId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'storeId': storeId,
      'warehouseId': warehouseId,
    };
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      storeId: json['storeId'],
      warehouseId: json['warehouseId'],
    );
  }
}
