import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/store_model.dart';
import '../../../../core/domain/entities/store.dart';

class StoresRemoteDataSource {
  final SupabaseClient supabaseClient;

  StoresRemoteDataSource(this.supabaseClient);

  Future<List<Store>> getStores() async {
    final response = await supabaseClient.from('stores').select();
    return (response as List)
        .map((json) => StoreModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> addStore(Store store) async {
    await supabaseClient
        .from('stores')
        .insert(StoreModel.fromEntity(store).toJson(includeId: false));
  }

  Future<void> updateStore(Store store) async {
    await supabaseClient
        .from('stores')
        .update(StoreModel.fromEntity(store).toJson())
        .eq('id', store.id);
  }

  Future<void> deleteStore(int id) async {
    await supabaseClient.from('stores').delete().eq('id', id);
  }
}
