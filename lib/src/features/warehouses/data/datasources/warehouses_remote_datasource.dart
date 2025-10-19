import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/warehouse_model.dart';
import '../../../../core/domain/entities/warehouse.dart';

class WarehousesRemoteDataSource {
  final SupabaseClient supabaseClient;

  WarehousesRemoteDataSource(this.supabaseClient);

  Future<List<Warehouse>> getWarehouses() async {
    final response = await supabaseClient.from('warehouses').select();
    return (response as List)
        .map((json) => WarehouseModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> addWarehouse(Warehouse warehouse) async {
    await supabaseClient
        .from('warehouses')
        .insert(WarehouseModel.fromEntity(warehouse).toJson(includeId: false));
  }

  Future<void> updateWarehouse(Warehouse warehouse) async {
    await supabaseClient
        .from('warehouses')
        .update(WarehouseModel.fromEntity(warehouse).toJson())
        .eq('id', warehouse.id);
  }

  Future<void> deleteWarehouse(int id) async {
    await supabaseClient.from('warehouses').delete().eq('id', id);
  }
}
