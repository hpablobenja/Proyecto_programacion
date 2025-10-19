import '../../../services/sync_service.dart';
import '../../../domain/entities/warehouse.dart';
import '../../../domain/repositories/warehouses_repository.dart';
import '../../../../features/warehouses/data/datasources/warehouses_local_datasource.dart';
import '../../../../features/warehouses/data/datasources/warehouses_remote_datasource.dart';

class WarehousesRepositoryImpl implements WarehousesRepository {
  final WarehousesLocalDataSource localDataSource;
  final WarehousesRemoteDataSource remoteDataSource;
  final SyncService syncService;

  WarehousesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Warehouse>> getWarehouses() async {
    try {
      print('🏢 Repository: Obteniendo almacenes desde Supabase...');
      final warehouses = await remoteDataSource.getWarehouses();
      print('🏢 Repository: ${warehouses.length} almacenes obtenidos');
      
      try {
        await localDataSource.saveWarehouses(warehouses);
      } catch (e) {
        print('⚠️ Repository: Error al guardar localmente: $e');
      }
      
      return warehouses;
    } catch (e) {
      print('⚠️ Repository: Error al obtener de Supabase, intentando local: $e');
      try {
        return await localDataSource.getWarehouses();
      } catch (localError) {
        print('❌ Repository: Error también en local: $localError');
        rethrow;
      }
    }
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) async {
    try {
      print('🏢 Repository: Agregando almacén a Supabase: ${warehouse.name}');
      await remoteDataSource.addWarehouse(warehouse);
      print('✅ Repository: Almacén agregado exitosamente');
      
      try {
        await localDataSource.addWarehouse(warehouse);
      } catch (e) {
        print('⚠️ Repository: Error al guardar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al agregar almacén: $e');
      throw Exception('Failed to add warehouse: $e');
    }
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    try {
      print('🏢 Repository: Actualizando almacén en Supabase: ${warehouse.name}');
      await remoteDataSource.updateWarehouse(warehouse);
      print('✅ Repository: Almacén actualizado exitosamente');
      
      try {
        await localDataSource.updateWarehouse(warehouse);
      } catch (e) {
        print('⚠️ Repository: Error al actualizar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al actualizar almacén: $e');
      throw Exception('Failed to update warehouse: $e');
    }
  }

  @override
  Future<void> deleteWarehouse(int id) async {
    try {
      print('🏢 Repository: Eliminando almacén de Supabase ID: $id');
      await remoteDataSource.deleteWarehouse(id);
      print('✅ Repository: Almacén eliminado exitosamente');
      
      try {
        await localDataSource.deleteWarehouse(id);
      } catch (e) {
        print('⚠️ Repository: Error al eliminar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al eliminar almacén: $e');
      throw Exception('Failed to delete warehouse: $e');
    }
  }
}
