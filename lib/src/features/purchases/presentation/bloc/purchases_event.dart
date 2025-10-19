abstract class PurchasesEvent {}

class LoadPurchasesEvent extends PurchasesEvent {
  final int? storeId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadPurchasesEvent(this.storeId, this.startDate, this.endDate);
}

class CreatePurchaseEvent extends PurchasesEvent {
  final dynamic purchase;

  CreatePurchaseEvent(this.purchase);
}
