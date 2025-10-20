import '../../../../core/domain/entities/report.dart';

abstract class ReportsEvent {}

class LoadReportsEvent extends ReportsEvent {}

class GenerateSalesReportEvent extends ReportsEvent {
  final int? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  GenerateSalesReportEvent({this.storeId, this.startDate, this.endDate});
}

class GeneratePurchasesReportEvent extends ReportsEvent {
  final int? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  GeneratePurchasesReportEvent({this.storeId, this.startDate, this.endDate});
}

class GenerateTransfersReportEvent extends ReportsEvent {
  final int? storeId;
  final int? warehouseId;
  final DateTime? startDate;
  final DateTime? endDate;

  GenerateTransfersReportEvent({
    this.storeId,
    this.warehouseId,
    this.startDate,
    this.endDate,
  });
}

class GenerateDailySalesReportEvent extends ReportsEvent {
  final DateTime? date;

  GenerateDailySalesReportEvent({this.date});
}

class ViewReportEvent extends ReportsEvent {
  final Report report;

  ViewReportEvent(this.report);
}
