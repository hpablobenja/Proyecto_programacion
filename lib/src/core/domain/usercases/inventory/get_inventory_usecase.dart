// lib/src/core/domain/usecases/inventory/get_inventory_usecase.dart
import '../../entities/product.dart';
import '../../repositories/inventory_repository.dart';

class GetInventoryUseCase {
  final InventoryRepository repository;

  GetInventoryUseCase(this.repository);

  Future<List<Product>> call({int? storeId, int? warehouseId}) async {
    return await repository.getInventory(
      storeId: storeId,
      warehouseId: warehouseId,
    );
  }
}

// core/domain/usercases/inventory/get_inventory_usecase.dart
