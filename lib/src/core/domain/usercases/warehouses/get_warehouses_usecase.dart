import '../../entities/warehouse.dart';
import '../../repositories/warehouses_repository.dart';

class GetWarehousesUseCase {
  final WarehousesRepository repository;

  GetWarehousesUseCase(this.repository);

  Future<List<Warehouse>> call() async {
    return await repository.getWarehouses();
  }
}
