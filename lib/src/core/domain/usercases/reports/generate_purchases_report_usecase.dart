import '../../entities/report.dart';
import '../../repositories/reports_repository.dart';

class GeneratePurchasesReportUseCase {
  final ReportsRepository repository;

  GeneratePurchasesReportUseCase(this.repository);

  Future<Report> call({
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.generatePurchasesReport(
      storeId: storeId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
