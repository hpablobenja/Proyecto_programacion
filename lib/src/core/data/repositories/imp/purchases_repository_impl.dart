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
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    if (await syncService.isOnline()) {
      final remotePurchases = await remoteDataSource.getPurchases(
        storeId,
        warehouseId,
        startDate,
        endDate,
      );
      await localDataSource.savePurchases(remotePurchases);
      await syncService.syncPendingTransactions();
      return remotePurchases;
    }
    return await localDataSource.getPurchases(
      storeId,
      warehouseId,
      startDate,
      endDate,
    );
  }

  @override
  Future<Purchase> createPurchase(Purchase purchase) async {
    // First create the purchase locally to get the generated ID
    final createdPurchase = await localDataSource.createPurchase(purchase);
    print('Purchase created locally with ID: ${createdPurchase.id}');

    // Always try to sync with Supabase first
    try {
      print('Attempting to sync purchase with Supabase...');
      await remoteDataSource.createPurchase(createdPurchase);
      print('✅ Purchase synced successfully with Supabase');
      await syncService.syncPendingTransactions();
    } catch (e) {
      print('❌ Error syncing purchase with Supabase: $e');
      print('📋 Enqueuing purchase for later sync...');
      // If remote sync fails, enqueue for later sync
      await syncService.enqueueTransaction(
        'create_purchase',
        PurchaseModel.fromEntity(createdPurchase),
      );
      print('✅ Purchase enqueued for later sync');
    }

    return createdPurchase;
  }
}
