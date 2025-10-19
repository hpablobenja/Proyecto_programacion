import '../../domain/entities/sale.dart';

class SaleModel {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final int? storeId;
  final DateTime createdAt;

  SaleModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    this.storeId,
    required this.createdAt,
  });

  factory SaleModel.fromEntity(Sale entity) {
    return SaleModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      employeeId: entity.employeeId,
      storeId: entity.storeId,
      createdAt: entity.createdAt,
    );
  }

  Sale toEntity() {
    return Sale(
      id: id,
      productId: productId,
      quantity: quantity,
      employeeId: employeeId,
      storeId: storeId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
      'employee_id': employeeId,
      'store_id': storeId,
      'created_at': createdAt.toIso8601String(),
    };
    
    if (includeId && id > 0) {
      json['id'] = id;
    }
    
    return json;
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      employeeId: json['employee_id'],
      storeId: json['store_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
