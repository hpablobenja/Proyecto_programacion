import '../entities/sale.dart';
import '../entities/purchase.dart';

abstract class ReportsRepository {
  Future<List<Sale>> getSalesReport(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<List<Purchase>> getPurchasesReport(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<double> getDailyGlobalSales(DateTime date);
}
