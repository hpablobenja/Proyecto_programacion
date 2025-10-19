import '../../domain/entities/store.dart';

class StoreModel {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreModel.fromEntity(Store entity) {
    return StoreModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      phone: entity.phone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Store toEntity() {
    return Store(
      id: id,
      name: name,
      address: address,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'name': name,
      'address': address,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
    
    if (includeId && id > 0) {
      json['id'] = id;
    }
    
    return json;
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '',
      phone: json['phone'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
