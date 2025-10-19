import '../../../../core/domain/entities/sale.dart';
import '../../../../core/domain/entities/purchase.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class SalesReportLoaded extends ReportsState {
  final List<Sale> sales;

  SalesReportLoaded(this.sales);
}

class PurchasesReportLoaded extends ReportsState {
  final List<Purchase> purchases;

  PurchasesReportLoaded(this.purchases);
}

class DailyGlobalSalesLoaded extends ReportsState {
  final double total;

  DailyGlobalSalesLoaded(this.total);
}

class ReportsError extends ReportsState {
  final String message;

  ReportsError(this.message);
}
