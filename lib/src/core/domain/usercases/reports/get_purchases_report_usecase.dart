import '../../entities/purchase.dart';
import '../../repositories/reports_repository.dart';

class GetPurchasesReportUseCase {
  final ReportsRepository repository;

  GetPurchasesReportUseCase(this.repository);

  Future<List<Purchase>> call(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    return await repository.getPurchasesReport(storeId, startDate, endDate);
  }
}
