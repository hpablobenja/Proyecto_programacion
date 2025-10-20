import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/transfer.dart' as domain;

class TransfersLocalDataSource {
  final AppDatabase database;

  TransfersLocalDataSource(this.database);

  Future<List<domain.Transfer>> getTransfers(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('transfer'));

    if (storeId != null) {
      query.where(
        (tbl) =>
            tbl.fromLocationId.equals(storeId) |
            tbl.toLocationId.equals(storeId),
      );
    }

    if (warehouseId != null) {
      query.where(
        (tbl) =>
            tbl.fromLocationId.equals(warehouseId) |
            tbl.toLocationId.equals(warehouseId),
      );
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
          (row) => domain.Transfer(
            id: row.id,
            productId: row.productId,
            quantity: row.quantity,
            employeeId: row.employeeId,
            fromLocationType: row.storeId != null ? 'store' : 'warehouse',
            fromLocationId: row.storeId ?? row.warehouseId ?? 0,
            toLocationType: row.warehouseId != null ? 'warehouse' : 'store',
            toLocationId: row.warehouseId ?? row.storeId ?? 0,
            notes: null, // Not available in Transactions table
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ),
        )
        .toList();
  }

  Future<void> saveTransfers(List<domain.Transfer> transfers) async {
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
              storeId: Value(
                transfer.fromLocationType == 'store'
                    ? transfer.fromLocationId
                    : null,
              ),
              warehouseId: Value(
                transfer.fromLocationType == 'warehouse'
                    ? transfer.fromLocationId
                    : null,
              ),
              createdAt: Value(transfer.createdAt),
              updatedAt: Value(transfer.updatedAt ?? transfer.createdAt),
              isSynced: const Value(true),
            ),
          );
    }
  }

  Future<domain.Transfer> createTransfer(domain.Transfer transfer) async {
    final id = await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion(
            id: Value.absent(),
            type: const Value('transfer'),
            productId: Value(transfer.productId),
            quantity: Value(transfer.quantity),
            employeeId: Value(transfer.employeeId),
            storeId: Value(
              transfer.fromLocationType == 'store'
                  ? transfer.fromLocationId
                  : null,
            ),
            warehouseId: Value(
              transfer.fromLocationType == 'warehouse'
                  ? transfer.fromLocationId
                  : null,
            ),
            createdAt: Value(transfer.createdAt),
            updatedAt: Value(transfer.updatedAt ?? transfer.createdAt),
            isSynced: const Value(false),
          ),
        );

    return transfer.copyWith(id: id);
  }
}
