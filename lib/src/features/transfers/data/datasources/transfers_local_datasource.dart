import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/transfer.dart';

class TransfersLocalDataSource {
  final AppDatabase database;

  TransfersLocalDataSource(this.database);

  Future<List<Transfer>> getTransfers(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('transfer'));
    if (storeId != null) query.where((tbl) => tbl.storeId.equals(storeId));
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
          (row) => Transfer(
            id: row.id,
            productId: row.productId,
            quantity: row.quantity,
            employeeId: row.employeeId,
            fromLocationId: row.storeId ?? row.warehouseId!,
            toLocationId: row.storeId ?? row.warehouseId!,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<void> saveTransfers(List<Transfer> transfers) async {
    for (var transfer in transfers) {
      await database
          .into(database.transactions)
          .insertOnConflictUpdate(
            TransactionsCompanion(
              id: Value(transfer.id),
              type: const Value('transfer'),
              productId: Value(transfer.productId),
              quantity: Value(transfer.quantity),
              employeeId: Value(transfer.employeeId),
              storeId: Value(transfer.fromLocationId),
              warehouseId: Value(transfer.toLocationId),
              createdAt: Value(transfer.createdAt),
              updatedAt: Value(transfer.createdAt),
              isSynced: const Value(true),
            ),
          );
    }
  }

  Future<void> createTransfer(Transfer transfer) async {
    await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion(
            id: Value(transfer.id),
            type: const Value('transfer'),
            productId: Value(transfer.productId),
            quantity: Value(transfer.quantity),
            employeeId: Value(transfer.employeeId),
            storeId: Value(transfer.fromLocationId),
            warehouseId: Value(transfer.toLocationId),
            createdAt: Value(transfer.createdAt),
            updatedAt: Value(transfer.createdAt),
            isSynced: const Value(false),
          ),
        );
  }
}
