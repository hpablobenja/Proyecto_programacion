import '../entities/purchase.dart';

abstract class PurchasesRepository {
  Future<List<Purchase>> getPurchases(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  );

  Future<Purchase> createPurchase(Purchase purchase);
}
