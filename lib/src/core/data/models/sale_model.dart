import '../../domain/entities/sale.dart';

class SaleModel {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final int? storeId;
  final int? warehouseId;
  final double? unitPrice;
  final double? totalPrice;
  final String? notes;
  final String? customerName;
  final String? customerPhone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SaleModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    this.storeId,
    this.warehouseId,
    this.unitPrice,
    this.totalPrice,
    this.notes,
    this.customerName,
    this.customerPhone,
    required this.createdAt,
    this.updatedAt,
  });

  factory SaleModel.fromEntity(Sale entity) {
    return SaleModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      employeeId: entity.employeeId,
      storeId: entity.storeId,
      warehouseId: entity.warehouseId,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
      notes: entity.notes,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Sale toEntity() {
    return Sale(
      id: id,
      productId: productId,
      quantity: quantity,
      employeeId: employeeId,
      storeId: storeId,
      warehouseId: warehouseId,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      notes: notes,
      customerName: customerName,
      customerPhone: customerPhone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
      'employee_id': employeeId,
      'store_id': storeId,
      'warehouse_id': warehouseId,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'notes': notes,
      'customer_name': customerName,
      'customer_phone': customerPhone,
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

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      employeeId: json['employee_id'],
      storeId: json['store_id'],
      warehouseId: json['warehouse_id'],
      unitPrice: json['unit_price']?.toDouble(),
      totalPrice: json['total_price']?.toDouble(),
      notes: json['notes'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
