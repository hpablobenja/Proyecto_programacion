import '../../entities/transfer.dart';
import '../../repositories/transfers_repository.dart';

class GetTransfersUseCase {
  final TransfersRepository repository;

  GetTransfersUseCase(this.repository);

  Future<List<Transfer>> call(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    return await repository.getTransfers(
      storeId,
      warehouseId,
      startDate,
      endDate,
    );
  }
}
