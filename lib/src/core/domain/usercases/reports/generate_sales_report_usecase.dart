import '../../entities/report.dart';
import '../../repositories/reports_repository.dart';

class GenerateSalesReportUseCase {
  final ReportsRepository repository;

  GenerateSalesReportUseCase(this.repository);

  Future<Report> call({
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.generateSalesReport(
      storeId: storeId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
