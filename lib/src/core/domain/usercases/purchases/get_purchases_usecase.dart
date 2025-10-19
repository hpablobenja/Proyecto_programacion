import '../../entities/purchase.dart';
import '../../repositories/purchases_repository.dart';

class GetPurchasesUseCase {
  final PurchasesRepository repository;

  GetPurchasesUseCase(this.repository);

  Future<List<Purchase>> call(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    return await repository.getPurchases(storeId, startDate, endDate);
  }
}
