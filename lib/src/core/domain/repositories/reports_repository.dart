import '../entities/report.dart';

abstract class ReportsRepository {
  Future<Report> generateSalesReport({
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Report> generatePurchasesReport({
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Report> generateTransfersReport({
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Report> generateDailySalesReport({DateTime? date});

  Future<List<Report>> getReportHistory();
}
