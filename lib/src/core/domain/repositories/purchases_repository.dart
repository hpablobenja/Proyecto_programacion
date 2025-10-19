import '../entities/purchase.dart';

abstract class PurchasesRepository {
  Future<List<Purchase>> getPurchases(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<void> createPurchase(Purchase purchase);
}
