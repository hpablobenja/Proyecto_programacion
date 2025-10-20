import '../../../domain/entities/product.dart';
import '../../../domain/repositories/inventory_repository.dart';
import '../../../../features/inventory/data/datasources/inventory_local_datasource.dart';
import '../../../../features/inventory/data/datasources/inventory_remote_datasource.dart';
import '../../../services/sync_service.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;
  final InventoryRemoteDataSource remoteDataSource;
  final SyncService syncService;

  InventoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<void> addProduct(Product product) async {
    // Guardar local primero para modo offline
    await localDataSource.addProduct(product);
    // Intento remoto best-effort
    try {
      await remoteDataSource.addProduct(product);
    } catch (_) {}
  }

  @override
  Future<void> deleteProduct(int productId) async {
    // Eliminar local primero (offline)
    await localDataSource.deleteProduct(productId);
    // Intento remoto best-effort
    try {
      await remoteDataSource.deleteProduct(productId);
    } catch (_) {}
  }

  @override
  Future<List<Product>> getInventory({int? storeId, int? warehouseId}) async {
    // Preferencia Offline First: usar local siempre; si hay conexión, refrescar en background
    final local = await localDataSource.getProducts(storeId, warehouseId);
    // Best-effort refresh
    try {
      final remote = await remoteDataSource.getProducts(storeId, warehouseId);
      // Guardar/actualizar localmente en background
      await localDataSource.saveProducts(remote);
      return remote.isNotEmpty ? remote : local;
    } catch (_) {
      return local;
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    // Actualizar local primero (offline)
    await localDataSource.updateProduct(product);
    // Intento remoto best-effort
    try {
      await remoteDataSource.updateProduct(product);
    } catch (_) {}
  }
}
