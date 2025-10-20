import '../../domain/entities/purchase.dart';

class PurchaseModel {
  final int id;
  final int productId;
  final int quantity;
  final double? unitPrice;
  final double? totalPrice;
  final int employeeId;
  final int? storeId;
  final int? warehouseId;
  final String? supplierName;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PurchaseModel({
    required this.id,
    required this.productId,
    required this.quantity,
    this.unitPrice,
    this.totalPrice,
    required this.employeeId,
    this.storeId,
    this.warehouseId,
    this.supplierName,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory PurchaseModel.fromEntity(Purchase entity) {
    return PurchaseModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
      employeeId: entity.employeeId,
      storeId: entity.storeId,
      warehouseId: entity.warehouseId,
      supplierName: entity.supplierName,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Purchase toEntity() {
    return Purchase(
      id: id,
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      employeeId: employeeId,
      storeId: storeId,
      warehouseId: warehouseId,
      supplierName: supplierName,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'employee_id': employeeId,
      'store_id': storeId,
      'warehouse_id': warehouseId,
      'supplier_name': supplierName,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };

    if (updatedAt != null) {
      json['updated_at'] = updatedAt!.toIso8601String();
    }

    if (includeId && id > 0) {
      json['id'] = id;
    }

    return json;
  }

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price']?.toDouble(),
      totalPrice: json['total_price']?.toDouble(),
      employeeId: json['employee_id'],
      storeId: json['store_id'],
      warehouseId: json['warehouse_id'],
      supplierName: json['supplier_name'],
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
