import '../../entities/store.dart';
import '../../repositories/stores_repository.dart';

class AddStoreUseCase {
  final StoresRepository repository;

  AddStoreUseCase(this.repository);

  Future<void> call(Store store) async {
    await repository.addStore(store);
  }
}
