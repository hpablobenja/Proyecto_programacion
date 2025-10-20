class Report {
  final String id;
  final String type; // 'sales', 'purchases', 'transfers', 'daily_sales'
  final String title;
  final String description;
  final Map<String, dynamic> data;
  final DateTime generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? storeId;
  final int? warehouseId;

  Report({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.data,
    required this.generatedAt,
    this.startDate,
    this.endDate,
    this.storeId,
    this.warehouseId,
  });

  Report copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    Map<String, dynamic>? data,
    DateTime? generatedAt,
    DateTime? startDate,
    DateTime? endDate,
    int? storeId,
    int? warehouseId,
  }) {
    return Report(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      data: data ?? this.data,
      generatedAt: generatedAt ?? this.generatedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      storeId: storeId ?? this.storeId,
      warehouseId: warehouseId ?? this.warehouseId,
    );
  }
}
