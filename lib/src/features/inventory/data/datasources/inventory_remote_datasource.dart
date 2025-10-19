import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/product_model.dart';
import '../../../../core/domain/entities/product.dart';

class InventoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  InventoryRemoteDataSource(this.supabaseClient);

  Future<List<Product>> getProducts(int? storeId, int? warehouseId) async {
    final query = supabaseClient.from('products').select();
    if (storeId != null) {
      query.eq('store_id', storeId);
    } else if (warehouseId != null) {
      query.eq('warehouse_id', warehouseId);
    }
    final response = await query;
    return (response as List)
        .map((json) => ProductModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> addProduct(Product product) async {
    print('🌐 RemoteDataSource: Insertando producto sin ID');
    await supabaseClient
        .from('products')
        .insert(ProductModel.fromEntity(product).toJson(includeId: false));
    print('✅ RemoteDataSource: Producto insertado exitosamente');
  }

  Future<void> updateProduct(Product product) async {
    await supabaseClient
        .from('products')
        .update(ProductModel.fromEntity(product).toJson())
        .eq('id', product.id);
  }

  Future<void> deleteProduct(int id) async {
    await supabaseClient.from('products').delete().eq('id', id);
  }
}
