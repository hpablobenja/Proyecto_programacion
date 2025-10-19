class Product {
  final int id;
  final String name;
  final String? variant;
  final int stock;
  final int? storeId;
  final int? warehouseId;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.variant,
    required this.stock,
    this.storeId,
    this.warehouseId,
    required this.updatedAt,
  });
}
