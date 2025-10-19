import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/purchase.dart';
import '../../../../core/domain/entities/sale.dart';

class ReportsLocalDataSource {
  final AppDatabase database;

  ReportsLocalDataSource(this.database);

  Future<List<Sale>> getSalesReport(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('sale'));
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
          (row) => Sale(
            id: row.id,
            productId: row.productId,
            quantity: row.quantity,
            employeeId: row.employeeId,
            storeId: row.storeId,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<List<Purchase>> getPurchasesReport(
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

  Future<double> getDailyGlobalSales(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('sale'))
      ..where((tbl) => tbl.createdAt.isBetweenValues(start, end));
    final result = await query.get();
    return result.fold<double>(
      0.0,
      (sum, row) => sum + (row.quantity.toDouble()),
    );
  }

  Future<void> saveSalesReport(List<Sale> sales) async {
    for (var sale in sales) {
      await database
          .into(database.transactions)
          .insertOnConflictUpdate(
            TransactionsCompanion(
              id: Value(sale.id),
              type: const Value('sale'),
              productId: Value(sale.productId),
              quantity: Value(sale.quantity),
              employeeId: Value(sale.employeeId),
              storeId: Value(sale.storeId),
              createdAt: Value(sale.createdAt),
              updatedAt: Value(sale.createdAt),
              isSynced: const Value(true),
            ),
          );
    }
  }

  Future<void> savePurchasesReport(List<Purchase> purchases) async {
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

  Future<void> saveDailyGlobalSales(DateTime date, double total) async {
    // Implementar si se necesita almacenamiento local del total
  }
}
