import '../../entities/sale.dart';
import '../../repositories/sales_repository.dart';

class GetSalesUseCase {
  final SalesRepository repository;

  GetSalesUseCase(this.repository);

  Future<List<Sale>> call(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    return await repository.getSales(storeId, startDate, endDate);
  }
}
// 'lib/src/core/domain/usercases/sales/get_sales_usecase.dart';