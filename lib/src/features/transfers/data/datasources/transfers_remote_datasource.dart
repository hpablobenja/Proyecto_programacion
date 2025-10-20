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

    if (storeId != null) {
      query.or('from_location_type.eq.store,to_location_type.eq.store');
      query.or('from_location_id.eq.$storeId,to_location_id.eq.$storeId');
    }

    if (warehouseId != null) {
      query.or('from_location_type.eq.warehouse,to_location_type.eq.warehouse');
      query.or(
        'from_location_id.eq.$warehouseId,to_location_id.eq.$warehouseId',
      );
    }

    if (startDate != null) {
      query.gte('created_at', startDate.toIso8601String());
    }

    if (endDate != null) {
      query.lte('created_at', endDate.toIso8601String());
    }

    final response = await query;
    return (response as List)
        .map((json) => TransferModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> createTransfer(Transfer transfer) async {
    print('RemoteDataSource: Creating transfer in Supabase...');
    print(
      'Transfer data: ${TransferModel.fromEntity(transfer).toJson(includeId: false)}',
    );

    try {
      final response = await supabaseClient
          .from('transfers')
          .insert(TransferModel.fromEntity(transfer).toJson(includeId: false));

      print('RemoteDataSource: Transfer created successfully in Supabase');
      print('Response: $response');
    } catch (e) {
      print('RemoteDataSource: Error creating transfer in Supabase: $e');
      rethrow;
    }
  }
}
