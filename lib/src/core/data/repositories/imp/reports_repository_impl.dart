import '../../../services/sync_service.dart';
import '../../../domain/entities/sale.dart';
import '../../../domain/entities/purchase.dart';
import '../../../domain/repositories/reports_repository.dart';
import '../../../../features/reports/data/datasources/reports_local_datasource.dart';
import '../../../../features/reports/data/datasources/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsLocalDataSource localDataSource;
  final ReportsRemoteDataSource remoteDataSource;
  final SyncService syncService;

  ReportsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Sale>> getSalesReport(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    if (await syncService.isOnline()) {
      final remoteSales = await remoteDataSource.getSalesReport(
        storeId,
        startDate,
        endDate,
      );
      await localDataSource.saveSalesReport(remoteSales);
      return remoteSales;
    }
    return await localDataSource.getSalesReport(storeId, startDate, endDate);
  }

  @override
  Future<List<Purchase>> getPurchasesReport(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    if (await syncService.isOnline()) {
      final remotePurchases = await remoteDataSource.getPurchasesReport(
        storeId,
        startDate,
        endDate,
      );
      await localDataSource.savePurchasesReport(remotePurchases);
      return remotePurchases;
    }
    return await localDataSource.getPurchasesReport(
      storeId,
      startDate,
      endDate,
    );
  }

  @override
  Future<double> getDailyGlobalSales(DateTime date) async {
    if (await syncService.isOnline()) {
      final total = await remoteDataSource.getDailyGlobalSales(date);
      await localDataSource.saveDailyGlobalSales(date, total);
      return total;
    }
    return await localDataSource.getDailyGlobalSales(date);
  }
}
