import '../../entities/store.dart';
import '../../repositories/stores_repository.dart';

class GetStoresUseCase {
  final StoresRepository repository;

  GetStoresUseCase(this.repository);

  Future<List<Store>> call() async {
    return await repository.getStores();
  }
}
