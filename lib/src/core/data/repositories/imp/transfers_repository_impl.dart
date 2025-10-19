import '../../../services/sync_service.dart';
import '../../models/transfer_model.dart';
import '../../../domain/entities/transfer.dart';
import '../../../domain/repositories/transfers_repository.dart';
import '../../../../features/transfers/data/datasources/transfers_local_datasource.dart';
import '../../../../features/transfers/data/datasources/transfers_remote_datasource.dart';

class TransfersRepositoryImpl implements TransfersRepository {
  final TransfersLocalDataSource localDataSource;
  final TransfersRemoteDataSource remoteDataSource;
  final SyncService syncService;

  TransfersRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Transfer>> getTransfers(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    if (await syncService.isOnline()) {
      final remoteTransfers = await remoteDataSource.getTransfers(
        storeId,
        warehouseId,
        startDate,
        endDate,
      );
      await localDataSource.saveTransfers(remoteTransfers);
      await syncService.syncPendingTransactions();
      return remoteTransfers;
    }
    return await localDataSource.getTransfers(
      storeId,
      warehouseId,
      startDate,
      endDate,
    );
  }

  @override
  Future<void> createTransfer(Transfer transfer) async {
    await localDataSource.createTransfer(transfer);
    if (await syncService.isOnline()) {
      await remoteDataSource.createTransfer(transfer);
      await syncService.syncPendingTransactions();
    } else {
      await syncService.enqueueTransaction(
        'create_transfer',
        TransferModel.fromEntity(transfer),
      );
    }
  }
}
