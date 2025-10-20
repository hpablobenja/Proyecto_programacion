import '../../../services/sync_service.dart';
import '../../models/sale_model.dart';
import '../../../domain/entities/sale.dart';
import '../../../domain/repositories/sales_repository.dart';
import '../../../../features/sales/data/datasources/sales_local_datasource.dart';
import '../../../../features/sales/data/datasources/sales_remote_datasource.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesLocalDataSource localDataSource;
  final SalesRemoteDataSource remoteDataSource;
  final SyncService syncService;

  SalesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Sale>> getSales(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    if (await syncService.isOnline()) {
      final remoteSales = await remoteDataSource.getSales(
        storeId,
        startDate,
        endDate,
      );
      await localDataSource.saveSales(remoteSales);
      await syncService.syncPendingTransactions();
      return remoteSales;
    }
    return await localDataSource.getSales(storeId, startDate, endDate);
  }

  @override
  Future<Sale> createSale(Sale sale) async {
    // First create the sale locally to get the generated ID
    final createdSale = await localDataSource.createSale(sale);
    print('Sale created locally with ID: ${createdSale.id}');

    // Always try to sync with Supabase first
    try {
      print('Attempting to sync with Supabase...');
      await remoteDataSource.createSale(createdSale);
      print('✅ Sale synced successfully with Supabase');
      await syncService.syncPendingTransactions();
    } catch (e) {
      print('❌ Error syncing with Supabase: $e');
      print('📋 Enqueuing sale for later sync...');
      // If remote sync fails, enqueue for later sync
      await syncService.enqueueTransaction(
        'create_sale',
        SaleModel.fromEntity(createdSale),
      );
      print('✅ Sale enqueued for later sync');
    }

    return createdSale;
  }

  @override
  Future<void> generateReceipt(int saleId) async {
    // Implementar lógica para generar recibo (PDF o imagen)
    await localDataSource.generateReceipt(saleId);
  }
}
