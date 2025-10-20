class Employee {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;
  final int? storeId;
  final int? warehouseId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.storeId,
    this.warehouseId,
    required this.createdAt,
    this.updatedAt,
  });

  Employee copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    int? storeId,
    int? warehouseId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      storeId: storeId ?? this.storeId,
      warehouseId: warehouseId ?? this.warehouseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
