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
    try {
      print('📦 Repository: Agregando producto a Supabase: ${product.name}');
      await remoteDataSource.addProduct(product);
      print('✅ Repository: Producto agregado exitosamente');
      
      // También guardar localmente
      try {
        await localDataSource.addProduct(product);
      } catch (e) {
        print('⚠️ Repository: Error al guardar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al agregar producto: $e');
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      print('📦 Repository: Eliminando producto de Supabase ID: $productId');
      await remoteDataSource.deleteProduct(productId);
      print('✅ Repository: Producto eliminado exitosamente');
      
      // También eliminar localmente
      try {
        await localDataSource.deleteProduct(productId);
      } catch (e) {
        print('⚠️ Repository: Error al eliminar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al eliminar producto: $e');
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<List<Product>> getInventory({int? storeId, int? warehouseId}) async {
    try {
      print('📦 Repository: Obteniendo inventario desde Supabase...');
      final products = await remoteDataSource.getProducts(storeId, warehouseId);
      print('📦 Repository: ${products.length} productos obtenidos');
      return products;
    } catch (e) {
      print('⚠️ Repository: Error al obtener de Supabase, intentando local: $e');
      // Si falla, intentar obtener de la base de datos local
      try {
        return await localDataSource.getProducts(storeId, warehouseId);
      } catch (localError) {
        print('❌ Repository: Error también en local: $localError');
        rethrow;
      }
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      print('📦 Repository: Actualizando producto en Supabase: ${product.name}');
      await remoteDataSource.updateProduct(product);
      print('✅ Repository: Producto actualizado exitosamente');
      
      // También actualizar localmente
      try {
        await localDataSource.updateProduct(product);
      } catch (e) {
        print('⚠️ Repository: Error al actualizar localmente: $e');
      }
    } catch (e) {
      print('❌ Repository: Error al actualizar producto: $e');
      throw Exception('Failed to update product: $e');
    }
  }
}
