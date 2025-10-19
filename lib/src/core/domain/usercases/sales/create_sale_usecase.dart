import '../../entities/sale.dart';
import '../../repositories/sales_repository.dart';

class CreateSaleUseCase {
  final SalesRepository repository;

  CreateSaleUseCase(this.repository);

  Future<Sale> call(Sale sale) async {
    return await repository.createSale(sale);
  }
}
