import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/warehouse.dart' as domain;

class WarehousesLocalDataSource {
  final AppDatabase database;

  WarehousesLocalDataSource(this.database);

  Future<List<domain.Warehouse>> getWarehouses() async {
    // Implementar almacenamiento local si necesario
    return [];
  }

  Future<void> saveWarehouses(List<domain.Warehouse> warehouses) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> addWarehouse(domain.Warehouse warehouse) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> updateWarehouse(domain.Warehouse warehouse) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> deleteWarehouse(int id) async {
    // Implementar almacenamiento local si necesario
  }
}
