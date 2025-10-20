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
  Future<Transfer> createTransfer(Transfer transfer) async {
    // First create the transfer locally to get the generated ID
    final createdTransfer = await localDataSource.createTransfer(transfer);
    print('Transfer created locally with ID: ${createdTransfer.id}');

    // Always try to sync with Supabase first
    try {
      print('Attempting to sync transfer with Supabase...');
      await remoteDataSource.createTransfer(createdTransfer);
      print('✅ Transfer synced successfully with Supabase');
      await syncService.syncPendingTransactions();
    } catch (e) {
      print('❌ Error syncing transfer with Supabase: $e');
      print('📋 Enqueuing transfer for later sync...');
      // If remote sync fails, enqueue for later sync
      await syncService.enqueueTransaction(
        'create_transfer',
        TransferModel.fromEntity(createdTransfer),
      );
      print('✅ Transfer enqueued for later sync');
    }

    return createdTransfer;
  }
}
