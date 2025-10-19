import '../../repositories/warehouses_repository.dart';

class DeleteWarehouseUseCase {
  final WarehousesRepository repository;

  DeleteWarehouseUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteWarehouse(id);
  }
}
