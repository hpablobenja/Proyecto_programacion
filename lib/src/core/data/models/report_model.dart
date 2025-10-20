import '../../domain/entities/report.dart';

class ReportModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final Map<String, dynamic> data;
  final DateTime generatedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? storeId;
  final int? warehouseId;

  ReportModel({
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

  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
      id: report.id,
      type: report.type,
      title: report.title,
      description: report.description,
      data: report.data,
      generatedAt: report.generatedAt,
      startDate: report.startDate,
      endDate: report.endDate,
      storeId: report.storeId,
      warehouseId: report.warehouseId,
    );
  }

  Report toEntity() {
    return Report(
      id: id,
      type: type,
      title: title,
      description: description,
      data: data,
      generatedAt: generatedAt,
      startDate: startDate,
      endDate: endDate,
      storeId: storeId,
      warehouseId: warehouseId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'data': data,
      'generatedAt': generatedAt.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'storeId': storeId,
      'warehouseId': warehouseId,
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      storeId: json['storeId'] as int?,
      warehouseId: json['warehouseId'] as int?,
    );
  }
}
