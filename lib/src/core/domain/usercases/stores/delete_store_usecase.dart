import '../../repositories/stores_repository.dart';

class DeleteStoreUseCase {
  final StoresRepository repository;

  DeleteStoreUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteStore(id);
  }
}
