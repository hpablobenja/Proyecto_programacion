class Purchase {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final DateTime createdAt;

  Purchase({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.employeeId,
    required this.createdAt,
  });
}
