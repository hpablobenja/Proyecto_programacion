import '../entities/product.dart';

abstract class InventoryRepository {
  Future<List<Product>> getInventory({int? storeId, int? warehouseId});
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(int productId);
}
