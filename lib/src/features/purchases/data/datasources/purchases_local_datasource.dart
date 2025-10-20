import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/purchase.dart' as domain;

class PurchasesLocalDataSource {
  final AppDatabase database;

  PurchasesLocalDataSource(this.database);

  Future<List<domain.Purchase>> getPurchases(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('purchase'));

    if (storeId != null) {
      query.where((tbl) => tbl.storeId.equals(storeId));
    }

    if (warehouseId != null) {
      query.where((tbl) => tbl.warehouseId.equals(warehouseId));
    }

    if (startDate != null) {
      query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(endDate));
    }

    final result = await query.get();
    return result
        .map(
          (row) => domain.Purchase(
            id: row.id,
            productId: row.productId,
            quantity: row.quantity,
            unitPrice: null, // Not available in Transactions table
            totalPrice: null, // Not available in Transactions table
            employeeId: row.employeeId,
            storeId: row.storeId,
            warehouseId: row.warehouseId,
            supplierName: null, // Not available in Transactions table
            notes: null, // Not available in Transactions table
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();
  }

  Future<void> savePurchases(List<domain.Purchase> purchases) async {
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
              storeId: Value(purchase.storeId),
              warehouseId: Value(purchase.warehouseId),
              createdAt: Value(purchase.createdAt),
              updatedAt: Value(purchase.updatedAt ?? purchase.createdAt),
              isSynced: const Value(true),
            ),
          );
    }
  }

  Future<domain.Purchase> createPurchase(domain.Purchase purchase) async {
    final id = await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion(
            id: Value.absent(),
            type: const Value('purchase'),
            productId: Value(purchase.productId),
            quantity: Value(purchase.quantity),
            employeeId: Value(purchase.employeeId),
            storeId: Value(purchase.storeId),
            warehouseId: Value(purchase.warehouseId),
            createdAt: Value(purchase.createdAt),
            updatedAt: Value(purchase.updatedAt ?? purchase.createdAt),
            isSynced: const Value(false),
          ),
        );

    return purchase.copyWith(id: id);
  }
}
