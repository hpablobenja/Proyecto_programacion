import '../../entities/purchase.dart';
import '../../repositories/purchases_repository.dart';

class CreatePurchaseUseCase {
  final PurchasesRepository repository;

  CreatePurchaseUseCase(this.repository);

  Future<Purchase> call(Purchase purchase) async {
    return await repository.createPurchase(purchase);
  }
}
