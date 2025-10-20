import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/local/app_database.dart';
import '../data/models/sale_model.dart';
import 'connectivity_service.dart';

class SyncService {
  final SupabaseClient supabaseClient;
  final AppDatabase appDatabase;
  final ConnectivityService connectivityService;

  SyncService({
    required this.supabaseClient,
    required this.appDatabase,
    required this.connectivityService,
  });

  Future<bool> isOnline() async {
    return await connectivityService.isConnected();
  }

  Future<void> enqueueTransaction(String type, dynamic data) async {
    // Guardar transacción pendiente en Drift
    if (data is SaleModel) {
      await appDatabase
          .into(appDatabase.transactions)
          .insert(
            TransactionsCompanion(
              type: Value(type),
              productId: Value(data.productId),
              quantity: Value(data.quantity),
              employeeId: Value(data.employeeId),
              storeId: Value(data.storeId),
              warehouseId: Value(data.warehouseId),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(false),
            ),
          );
    } else {
      // Para otros tipos de datos, usar valores por defecto
      await appDatabase
          .into(appDatabase.transactions)
          .insert(
            TransactionsCompanion(
              type: Value(type),
              productId: const Value(0), // Valor por defecto
              quantity: const Value(0), // Valor por defecto
              employeeId: const Value(0), // Valor por defecto
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(false),
            ),
          );
    }
  }

  Future<void> syncPendingTransactions() async {
    if (!await isOnline()) return;

    final pending = await (appDatabase.select(
      appDatabase.transactions,
    )..where((tbl) => tbl.isSynced.equals(false))).get();

    for (var transaction in pending) {
      // Implementar lógica de sincronización según tipo
      // Ejemplo: enviar a Supabase y marcar como isSynced: true
      await (appDatabase.update(appDatabase.transactions)
            ..where((tbl) => tbl.id.equals(transaction.id)))
          .write(const TransactionsCompanion(isSynced: Value(true)));
    }
  }
}
