class Store {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Store({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });
}
