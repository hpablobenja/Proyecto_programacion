import '../../../../core/domain/entities/sale.dart';

abstract class SalesEvent {}

class LoadSalesEvent extends SalesEvent {
  final int? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadSalesEvent(this.storeId, this.startDate, this.endDate);
}

class CreateSaleEvent extends SalesEvent {
  final Sale sale;

  CreateSaleEvent(this.sale);
}
