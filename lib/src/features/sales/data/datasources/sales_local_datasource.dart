import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/sale.dart';

class SalesLocalDataSource {
  final AppDatabase database;

  SalesLocalDataSource(this.database);

  Future<List<Sale>> getSales(
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
    
    // Filter out any rows with invalid or temporary negative IDs
    return result
        .where((row) => row.id > 0) // Only include rows with valid positive IDs
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

  Future<void> saveSales(List<Sale> sales) async {
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

  Future<Sale> createSale(Sale sale) async {
    final id = await database.into(database.transactions).insert(
          TransactionsCompanion(
            type: const Value('sale'),
            productId: Value(sale.productId),
            quantity: Value(sale.quantity),
            employeeId: Value(sale.employeeId),
            storeId: Value(sale.storeId),
            // Set warehouseId to null if not provided
            warehouseId: Value(sale.warehouseId ?? 1), // Default to 1 if not specified
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
