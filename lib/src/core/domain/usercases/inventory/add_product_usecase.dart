import '../../entities/product.dart';
import '../../repositories/inventory_repository.dart';

class AddProductUseCase {
  final InventoryRepository repository;

  AddProductUseCase(this.repository);

  Future<void> call(Product product) async {
    await repository.addProduct(product);
  }
}
