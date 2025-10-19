import '../../domain/entities/transaction.dart';

class TransactionModel {
  final int id;
  final String type;
  final int productId;
  final int quantity;
  final int employeeId;
  final int? storeId;
  final int? warehouseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  TransactionModel({
    required this.id,
    required this.type,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    this.storeId,
    this.warehouseId,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      productId: entity.productId,
      quantity: entity.quantity,
      employeeId: entity.employeeId,
      storeId: entity.storeId,
      warehouseId: entity.warehouseId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      type: type,
      productId: productId,
      quantity: quantity,
      employeeId: employeeId,
      storeId: storeId,
      warehouseId: warehouseId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'product_id': productId,
      'quantity': quantity,
      'employee_id': employeeId,
      'store_id': storeId,
      'warehouse_id': warehouseId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: json['type'],
      productId: json['product_id'],
      quantity: json['quantity'],
      employeeId: json['employee_id'],
      storeId: json['store_id'],
      warehouseId: json['warehouse_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isSynced: json['is_synced'],
    );
  }
}
