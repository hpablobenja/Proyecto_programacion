abstract class ReportsEvent {}

class LoadSalesReportEvent extends ReportsEvent {
  final int? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadSalesReportEvent(this.storeId, this.startDate, this.endDate);
}

class LoadPurchasesReportEvent extends ReportsEvent {
  final int? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadPurchasesReportEvent(this.storeId, this.startDate, this.endDate);
}

class LoadDailyGlobalSalesEvent extends ReportsEvent {
  final DateTime date;

  LoadDailyGlobalSalesEvent(this.date);
}
