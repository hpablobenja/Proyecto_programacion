import '../entities/store.dart';

abstract class StoresRepository {
  Future<List<Store>> getStores();
  Future<void> addStore(Store store);
  Future<void> updateStore(Store store);
  Future<void> deleteStore(int id);
}
