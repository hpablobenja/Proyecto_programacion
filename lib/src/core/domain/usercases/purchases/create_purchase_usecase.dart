import '../../entities/purchase.dart';
import '../../repositories/purchases_repository.dart';

class CreatePurchaseUseCase {
  final PurchasesRepository repository;

  CreatePurchaseUseCase(this.repository);

  Future<void> call(Purchase purchase) async {
    await repository.createPurchase(purchase);
  }
}
