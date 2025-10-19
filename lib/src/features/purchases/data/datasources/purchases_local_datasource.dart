import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/purchase.dart';

class PurchasesLocalDataSource {
  final AppDatabase database;

  PurchasesLocalDataSource(this.database);

  Future<List<Purchase>> getPurchases(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('purchase'));
    if (storeId != null) query.where((tbl) => tbl.storeId.equals(storeId));
    if (startDate != null) {
      query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(endDate));
    }
    final result = await query.get();
    return result
        .map(
          (row) => Purchase(
            id: row.id,
            productId: row.productId,
            quantity: row.quantity,
            employeeId: row.employeeId,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<void> savePurchases(List<Purchase> purchases) async {
    for (var purchase in purchases) {
      await database
          .into(database.transactions)
          .insertOnConflictUpdate(
            TransactionsCompanion(
              id: Value(purchase.id),
              type: const Value('purchase'),
              productId: Value(purchase.productId),
              quantity: Value(purchase.quantity),
              employeeId: Value(purchase.employeeId),
              storeId: Value(purchase.employeeId),
              createdAt: Value(purchase.createdAt),
              updatedAt: Value(purchase.createdAt),
              isSynced: const Value(true),
            ),
          );
    }
  }

  Future<void> createPurchase(Purchase purchase) async {
    await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion(
            id: Value(purchase.id),
            type: const Value('purchase'),
            productId: Value(purchase.productId),
            quantity: Value(purchase.quantity),
            employeeId: Value(purchase.employeeId),
            storeId: Value(purchase.employeeId),
            createdAt: Value(purchase.createdAt),
            updatedAt: Value(purchase.createdAt),
            isSynced: const Value(false),
          ),
        );
  }
}
