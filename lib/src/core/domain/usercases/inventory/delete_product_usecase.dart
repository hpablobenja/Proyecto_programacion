import '../../repositories/inventory_repository.dart';

class DeleteProductUseCase {
  final InventoryRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteProduct(id);
  }
}
