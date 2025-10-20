import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/sale.dart' as domain;

class SalesLocalDataSource {
  final AppDatabase database;

  SalesLocalDataSource(this.database);

  Future<List<domain.Sale>> getSales(
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
          (row) => domain.Sale(
            id: row.id,
            productId: row.productId,
            quantity: row.quantity,
            employeeId: row.employeeId,
            storeId: row.storeId,
            warehouseId: null, // Sales don't have warehouseId
            unitPrice: null, // Will be added to database schema later
            totalPrice: null, // Will be added to database schema later
            notes: null, // Will be added to database schema later
            customerName: null, // Will be added to database schema later
            customerPhone: null, // Will be added to database schema later
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();
  }

  Future<void> saveSales(List<domain.Sale> sales) async {
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
              warehouseId: Value(null), // Sales don't have warehouseId
              createdAt: Value(sale.createdAt),
              updatedAt: Value(sale.createdAt),
              isSynced: const Value(true),
            ),
          );
    }
  }

  Future<domain.Sale> createSale(domain.Sale sale) async {
    final id = await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion(
            id: Value.absent(),
            type: const Value('sale'),
            productId: Value(sale.productId),
            quantity: Value(sale.quantity),
            employeeId: Value(sale.employeeId),
            storeId: Value(sale.storeId),
            warehouseId: Value(null), // Sales don't have warehouseId
            createdAt: Value(sale.createdAt),
            updatedAt: Value(sale.createdAt),
            isSynced: const Value(false),
          ),
        );

    // Return the sale with the generated ID
    return sale.copyWith(id: id);
  }

  Future<void> generateReceipt(int saleId) async {
    // Implementar lógica para generar recibo local
  }
}
