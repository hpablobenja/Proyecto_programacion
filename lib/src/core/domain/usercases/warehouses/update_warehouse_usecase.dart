import '../../entities/warehouse.dart';
import '../../repositories/warehouses_repository.dart';

class UpdateWarehouseUseCase {
  final WarehousesRepository repository;

  UpdateWarehouseUseCase(this.repository);

  Future<void> call(Warehouse warehouse) async {
    await repository.updateWarehouse(warehouse);
  }
}
