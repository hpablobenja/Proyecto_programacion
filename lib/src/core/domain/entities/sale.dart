class Sale {
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

  Sale({
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

  Sale copyWith({
    int? id,
    int? productId,
    int? quantity,
    int? employeeId,
    int? storeId,
    int? warehouseId,
    double? unitPrice,
    double? totalPrice,
    String? notes,
    String? customerName,
    String? customerPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sale(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      employeeId: employeeId ?? this.employeeId,
      storeId: storeId ?? this.storeId,
      warehouseId: warehouseId ?? this.warehouseId,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
