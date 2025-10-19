class Transaction {
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

  Transaction({
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
}
