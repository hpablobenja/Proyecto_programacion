import '../../domain/entities/purchase.dart';

class PurchaseModel {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final DateTime createdAt;

  PurchaseModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    required this.createdAt,
  });

  factory PurchaseModel.fromEntity(Purchase entity) {
    return PurchaseModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      employeeId: entity.employeeId,
      createdAt: entity.createdAt,
    );
  }

  Purchase toEntity() {
    return Purchase(
      id: id,
      productId: productId,
      quantity: quantity,
      employeeId: employeeId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'employee_id': employeeId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      employeeId: json['employee_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
