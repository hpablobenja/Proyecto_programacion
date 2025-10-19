class Sale {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final int? storeId;
  final int? warehouseId;
  final DateTime createdAt;

  Sale({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    this.storeId,
    this.warehouseId,
    required this.createdAt,
  });

  Sale copyWith({
    int? id,
    int? productId,
    int? quantity,
    int? employeeId,
    int? storeId,
    int? warehouseId,
    DateTime? createdAt,
  }) {
    return Sale(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      employeeId: employeeId ?? this.employeeId,
      storeId: storeId ?? this.storeId,
      warehouseId: warehouseId ?? this.warehouseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
