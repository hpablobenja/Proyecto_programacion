class Transfer {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final int fromLocationId;
  final int toLocationId;
  final DateTime createdAt;

  Transfer({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    required this.fromLocationId,
    required this.toLocationId,
    required this.createdAt,
  });
}
