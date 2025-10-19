import '../../entities/warehouse.dart';
import '../../repositories/warehouses_repository.dart';

class AddWarehouseUseCase {
  final WarehousesRepository repository;

  AddWarehouseUseCase(this.repository);

  Future<void> call(Warehouse warehouse) async {
    await repository.addWarehouse(warehouse);
  }
}
