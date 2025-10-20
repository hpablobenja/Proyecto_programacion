class Transfer {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final String fromLocationType; // 'store' or 'warehouse'
  final int fromLocationId;
  final String toLocationType; // 'store' or 'warehouse'
  final int toLocationId;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Transfer({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    required this.fromLocationType,
    required this.fromLocationId,
    required this.toLocationType,
    required this.toLocationId,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  Transfer copyWith({
    int? id,
    int? productId,
    int? quantity,
    int? employeeId,
    String? fromLocationType,
    int? fromLocationId,
    String? toLocationType,
    int? toLocationId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transfer(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      employeeId: employeeId ?? this.employeeId,
      fromLocationType: fromLocationType ?? this.fromLocationType,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationType: toLocationType ?? this.toLocationType,
      toLocationId: toLocationId ?? this.toLocationId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
