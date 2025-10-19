class Employee {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? storeId;
  final int? warehouseId;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.storeId,
    this.warehouseId,
  });
}
