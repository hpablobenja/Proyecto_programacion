import '../entities/warehouse.dart';

abstract class WarehousesRepository {
  Future<List<Warehouse>> getWarehouses();
  Future<void> addWarehouse(Warehouse warehouse);
  Future<void> updateWarehouse(Warehouse warehouse);
  Future<void> deleteWarehouse(int id);
}
