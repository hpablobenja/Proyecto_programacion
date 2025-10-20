import '../../../../core/domain/entities/purchase.dart';

abstract class PurchasesEvent {}

class LoadPurchasesEvent extends PurchasesEvent {
  final int? storeId;
  final int? warehouseId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadPurchasesEvent({
    this.storeId,
    this.warehouseId,
    this.startDate,
    this.endDate,
  });
}

class CreatePurchaseEvent extends PurchasesEvent {
  final Purchase purchase;

  CreatePurchaseEvent(this.purchase);
}
