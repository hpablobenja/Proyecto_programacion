import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/sale_model.dart';
import '../../../../core/domain/entities/sale.dart';

class SalesRemoteDataSource {
  final SupabaseClient supabaseClient;

  SalesRemoteDataSource(this.supabaseClient);

  Future<List<Sale>> getSales(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = supabaseClient.from('sales').select();
    if (storeId != null) query.eq('store_id', storeId);
    if (startDate != null) query.gte('created_at', startDate.toIso8601String());
    if (endDate != null) query.lte('created_at', endDate.toIso8601String());
    final response = await query;
    return (response as List)
        .map((json) => SaleModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> createSale(Sale sale) async {
    await supabaseClient
        .from('sales')
        .insert(SaleModel.fromEntity(sale).toJson());
  }

  Future<void> generateReceipt(int saleId) async {
    // Implementar lógica para generar recibo remoto
  }
}
