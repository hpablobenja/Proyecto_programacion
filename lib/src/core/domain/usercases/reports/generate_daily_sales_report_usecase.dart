import '../../entities/report.dart';
import '../../repositories/reports_repository.dart';

class GenerateDailySalesReportUseCase {
  final ReportsRepository repository;

  GenerateDailySalesReportUseCase(this.repository);

  Future<Report> call({DateTime? date}) async {
    return await repository.generateDailySalesReport(date: date);
  }
}
