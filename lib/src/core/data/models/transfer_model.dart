import '../../domain/entities/transfer.dart';

class TransferModel {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final int fromLocationId;
  final int toLocationId;
  final DateTime createdAt;

  TransferModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    required this.fromLocationId,
    required this.toLocationId,
    required this.createdAt,
  });

  factory TransferModel.fromEntity(Transfer entity) {
    return TransferModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      employeeId: entity.employeeId,
      fromLocationId: entity.fromLocationId,
      toLocationId: entity.toLocationId,
      createdAt: entity.createdAt,
    );
  }

  Transfer toEntity() {
    return Transfer(
      id: id,
      productId: productId,
      quantity: quantity,
      employeeId: employeeId,
      fromLocationId: fromLocationId,
      toLocationId: toLocationId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'employee_id': employeeId,
      'from_location_id': fromLocationId,
      'to_location_id': toLocationId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      employeeId: json['employee_id'],
      fromLocationId: json['from_location_id'],
      toLocationId: json['to_location_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
