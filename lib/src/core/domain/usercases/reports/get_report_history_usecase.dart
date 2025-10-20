import '../../entities/report.dart';
import '../../repositories/reports_repository.dart';

class GetReportHistoryUseCase {
  final ReportsRepository repository;

  GetReportHistoryUseCase(this.repository);

  Future<List<Report>> call() async {
    return await repository.getReportHistory();
  }
}
