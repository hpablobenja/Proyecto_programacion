import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/purchase_model.dart';
import '../../../../core/domain/entities/purchase.dart';

class PurchasesRemoteDataSource {
  final SupabaseClient supabaseClient;

  PurchasesRemoteDataSource(this.supabaseClient);

  Future<List<Purchase>> getPurchases(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = supabaseClient.from('purchases').select();

    if (storeId != null) {
      query.eq('store_id', storeId);
    }

    if (warehouseId != null) {
      query.eq('warehouse_id', warehouseId);
    }

    if (startDate != null) {
      query.gte('created_at', startDate.toIso8601String());
    }

    if (endDate != null) {
      query.lte('created_at', endDate.toIso8601String());
    }

    final response = await query;
    return (response as List)
        .map((json) => PurchaseModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> createPurchase(Purchase purchase) async {
    print('RemoteDataSource: Creating purchase in Supabase...');
    print(
      'Purchase data: ${PurchaseModel.fromEntity(purchase).toJson(includeId: false)}',
    );

    try {
      final response = await supabaseClient
          .from('purchases')
          .insert(PurchaseModel.fromEntity(purchase).toJson(includeId: false));

      print('RemoteDataSource: Purchase created successfully in Supabase');
      print('Response: $response');
    } catch (e) {
      print('RemoteDataSource: Error creating purchase in Supabase: $e');
      rethrow;
    }
  }
}
