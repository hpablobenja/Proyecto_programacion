import '../../../services/sync_service.dart';
import '../../../domain/entities/store.dart';
import '../../../domain/repositories/stores_repository.dart';
import '../../../../features/stores/data/datasources/stores_local_datasource.dart';
import '../../../../features/stores/data/datasources/stores_remote_datasource.dart';

class StoresRepositoryImpl implements StoresRepository {
  final StoresLocalDataSource localDataSource;
  final StoresRemoteDataSource remoteDataSource;
  final SyncService syncService;

  StoresRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Store>> getStores() async {
    try {
      print('🏪 Repository: Obteniendo tiendas desde Supabase...');
      final stores = await remoteDataSource.getStores();
      print('🏪 Repository: ${stores.length} tiendas obtenidas');
      
      // Guardar localmente
      try {
        await localDataSource.saveStores(stores);
      } catch (e) {
        print('⚠️ Repository: Error al guardar localmente: $e');
      }
      
      return stores;
    } catch (e) {
      print('⚠️ Repository: Error al obtener de Supabase, intentando local: $e');
      try {
        return await localDataSource.getStores();
      } catch (localError) {
        print('❌ Repository: Error también en local: $localError');
        rethrow;
      }
    }
  }

  @override
  Future<void> addStore(Store store) async {
    try {
      print('🏪 Repository: Agregando tienda a Supabase: ${store.name}');
      await remoteDataSource.addStore(store);
      print('✅ Repository: Tienda agregada exitosamente');
      
      // También guardar localmente
      try {
        await localDataSource.addStore(store);
      } catch (e) {
        print('⚠️ Repository: Error al guardar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al agregar tienda: $e');
      throw Exception('Failed to add store: $e');
    }
  }

  @override
  Future<void> updateStore(Store store) async {
    try {
      print('🏪 Repository: Actualizando tienda en Supabase: ${store.name}');
      await remoteDataSource.updateStore(store);
      print('✅ Repository: Tienda actualizada exitosamente');
      
      // También actualizar localmente
      try {
        await localDataSource.updateStore(store);
      } catch (e) {
        print('⚠️ Repository: Error al actualizar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al actualizar tienda: $e');
      throw Exception('Failed to update store: $e');
    }
  }

  @override
  Future<void> deleteStore(int id) async {
    try {
      print('🏪 Repository: Eliminando tienda de Supabase ID: $id');
      await remoteDataSource.deleteStore(id);
      print('✅ Repository: Tienda eliminada exitosamente');
      
      // También eliminar localmente
      try {
        await localDataSource.deleteStore(id);
      } catch (e) {
        print('⚠️ Repository: Error al eliminar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al eliminar tienda: $e');
      throw Exception('Failed to delete store: $e');
    }
  }
}
