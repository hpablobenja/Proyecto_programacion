import '../../../services/sync_service.dart';
import '../../models/purchase_model.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../../features/purchases/data/datasources/purchases_local_datasource.dart';
import '../../../../features/purchases/data/datasources/purchases_remote_datasource.dart';

class PurchasesRepositoryImpl implements PurchasesRepository {
  final PurchasesLocalDataSource localDataSource;
  final PurchasesRemoteDataSource remoteDataSource;
  final SyncService syncService;

  PurchasesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Purchase>> getPurchases(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    if (await syncService.isOnline()) {
      final remotePurchases = await remoteDataSource.getPurchases(
        storeId,
        startDate,
        endDate,
      );
      await localDataSource.savePurchases(remotePurchases);
      await syncService.syncPendingTransactions();
      return remotePurchases;
    }
    return await localDataSource.getPurchases(storeId, startDate, endDate);
  }

  @override
  Future<void> createPurchase(Purchase purchase) async {
    await localDataSource.createPurchase(purchase);
    if (await syncService.isOnline()) {
      await remoteDataSource.createPurchase(purchase);
      await syncService.syncPendingTransactions();
    } else {
      await syncService.enqueueTransaction(
        'create_purchase',
        PurchaseModel.fromEntity(purchase),
      );
    }
  }
}
