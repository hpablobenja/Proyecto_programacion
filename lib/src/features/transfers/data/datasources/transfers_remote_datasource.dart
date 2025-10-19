import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/transfer_model.dart';
import '../../../../core/domain/entities/transfer.dart';

class TransfersRemoteDataSource {
  final SupabaseClient supabaseClient;

  TransfersRemoteDataSource(this.supabaseClient);

  Future<List<Transfer>> getTransfers(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final query = supabaseClient.from('transfers').select();
    if (storeId != null) query.eq('from_location_id', storeId);
    if (warehouseId != null) query.eq('to_location_id', warehouseId);
    if (startDate != null) query.gte('created_at', startDate.toIso8601String());
    if (endDate != null) query.lte('created_at', endDate.toIso8601String());
    final response = await query;
    return (response as List)
        .map((json) => TransferModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> createTransfer(Transfer transfer) async {
    await supabaseClient
        .from('transfers')
        .insert(TransferModel.fromEntity(transfer).toJson());
  }
}
