import '../../domain/entities/transfer.dart';

class TransferModel {
  final int id;
  final int productId;
  final int quantity;
  final int employeeId;
  final String fromLocationType;
  final int fromLocationId;
  final String toLocationType;
  final int toLocationId;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TransferModel({
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

  factory TransferModel.fromEntity(Transfer entity) {
    return TransferModel(
      id: entity.id,
      productId: entity.productId,
      quantity: entity.quantity,
      employeeId: entity.employeeId,
      fromLocationType: entity.fromLocationType,
      fromLocationId: entity.fromLocationId,
      toLocationType: entity.toLocationType,
      toLocationId: entity.toLocationId,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Transfer toEntity() {
    return Transfer(
      id: id,
      productId: productId,
      quantity: quantity,
      employeeId: employeeId,
      fromLocationType: fromLocationType,
      fromLocationId: fromLocationId,
      toLocationType: toLocationType,
      toLocationId: toLocationId,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
      'employee_id': employeeId,
      'from_location_type': fromLocationType,
      'from_location_id': fromLocationId,
      'to_location_type': toLocationType,
      'to_location_id': toLocationId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };

    if (updatedAt != null) {
      json['updated_at'] = updatedAt!.toIso8601String();
    }

    if (includeId && id > 0) {
      json['id'] = id;
    }

    return json;
  }

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      employeeId: json['employee_id'],
      fromLocationType: json['from_location_type'],
      fromLocationId: json['from_location_id'],
      toLocationType: json['to_location_type'],
      toLocationId: json['to_location_id'],
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
