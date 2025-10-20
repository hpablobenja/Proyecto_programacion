import '../../entities/report.dart';
import '../../repositories/reports_repository.dart';

class GenerateTransfersReportUseCase {
  final ReportsRepository repository;

  GenerateTransfersReportUseCase(this.repository);

  Future<Report> call({
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.generateTransfersReport(
      storeId: storeId,
      warehouseId: warehouseId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
