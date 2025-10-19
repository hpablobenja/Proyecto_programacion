import '../../entities/sale.dart';
import '../../repositories/reports_repository.dart';

class GetSalesReportUseCase {
  final ReportsRepository repository;

  GetSalesReportUseCase(this.repository);

  Future<List<Sale>> call(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    return await repository.getSalesReport(storeId, startDate, endDate);
  }
}
