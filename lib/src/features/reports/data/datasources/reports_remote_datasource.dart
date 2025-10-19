import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/sale_model.dart';
import '../../../../core/data/models/purchase_model.dart';
import '../../../../core/domain/entities/purchase.dart';
import '../../../../core/domain/entities/sale.dart';

class ReportsRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReportsRemoteDataSource(this.supabaseClient);

  Future<List<Sale>> getSalesReport(
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

  Future<List<Purchase>> getPurchasesReport(
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

  Future<double> getDailyGlobalSales(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day).toIso8601String();
    final end = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
    ).toIso8601String();
    final response = await supabaseClient
        .from('sales')
        .select('quantity')
        .gte('created_at', start)
        .lte('created_at', end);
    return (response as List).fold<double>(
      0.0,
      (sum, item) => sum + (item['quantity'] as num).toDouble(),
    );
  }
}
