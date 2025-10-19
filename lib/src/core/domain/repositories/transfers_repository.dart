import '../entities/transfer.dart';

abstract class TransfersRepository {
  Future<List<Transfer>> getTransfers(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<void> createTransfer(Transfer transfer);
}
