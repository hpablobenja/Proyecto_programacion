class Purchase {
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

  Purchase({
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

  Purchase copyWith({
    int? id,
    int? productId,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    int? employeeId,
    int? storeId,
    int? warehouseId,
    String? supplierName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Purchase(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      employeeId: employeeId ?? this.employeeId,
      storeId: storeId ?? this.storeId,
      warehouseId: warehouseId ?? this.warehouseId,
      supplierName: supplierName ?? this.supplierName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
