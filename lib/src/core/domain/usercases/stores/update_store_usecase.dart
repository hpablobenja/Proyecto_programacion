import '../../entities/store.dart';
import '../../repositories/stores_repository.dart';

class UpdateStoreUseCase {
  final StoresRepository repository;

  UpdateStoreUseCase(this.repository);

  Future<void> call(Store store) async {
    await repository.updateStore(store);
  }
}
