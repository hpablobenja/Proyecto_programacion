import '../../repositories/reports_repository.dart';

class GetDailyGlobalSalesUseCase {
  final ReportsRepository repository;

  GetDailyGlobalSalesUseCase(this.repository);

  Future<double> call(DateTime date) async {
    return await repository.getDailyGlobalSales(date);
  }
}
