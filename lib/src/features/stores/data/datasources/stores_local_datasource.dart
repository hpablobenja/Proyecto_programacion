import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/store.dart' as domain;

class StoresLocalDataSource {
  final AppDatabase database;

  StoresLocalDataSource(this.database);

  Future<List<domain.Store>> getStores() async {
    // Implementar almacenamiento local si necesario
    return [];
  }

  Future<void> saveStores(List<domain.Store> stores) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> addStore(domain.Store store) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> updateStore(domain.Store store) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> deleteStore(int id) async {
    // Implementar almacenamiento local si necesario
  }
}
