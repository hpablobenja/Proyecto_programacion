import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/purchase_model.dart';
import '../../../../core/domain/entities/purchase.dart';

class PurchasesRemoteDataSource {
  final SupabaseClient supabaseClient;

  PurchasesRemoteDataSource(this.supabaseClient);

  Future<List<Purchase>> getPurchases(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = supabaseClient.from('purchases').select();
    if (storeId != null) query.eq('store_id', storeId);
    if (startDate != null) query.gte('created_at', startDate.toIso8601String());
    if (endDate != null) query.lte('created_at', endDate.toIso8601String());
    final response = await query;
    return (response as List)
        .map((json) => PurchaseModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> createPurchase(Purchase purchase) async {
    await supabaseClient
        .from('purchases')
        .insert(PurchaseModel.fromEntity(purchase).toJson());
  }
}
