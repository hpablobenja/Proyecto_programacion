import '../../domain/entities/product.dart';

class ProductModel {
  final int id;
  final String name;
  final String? variant;
  final int stock;
  final int? storeId;
  final int? warehouseId;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.variant,
    required this.stock,
    this.storeId,
    this.warehouseId,
    required this.updatedAt,
  });

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      variant: entity.variant,
      stock: entity.stock,
      storeId: entity.storeId,
      warehouseId: entity.warehouseId,
      updatedAt: entity.updatedAt,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      variant: variant,
      stock: stock,
      storeId: storeId,
      warehouseId: warehouseId,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = {
      'name': name,
      'variant': variant,
      'stock': stock,
      'store_id': storeId,
      'warehouse_id': warehouseId,
      'updated_at': updatedAt.toIso8601String(),
    };
    
    // Solo incluir el ID si es mayor a 0 y se solicita
    if (includeId && id > 0) {
      json['id'] = id;
    }
    
    return json;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      variant: json['variant'],
      stock: json['stock'],
      storeId: json['store_id'],
      warehouseId: json['warehouse_id'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
