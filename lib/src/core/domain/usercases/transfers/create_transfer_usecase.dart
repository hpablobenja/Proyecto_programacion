import '../../entities/transfer.dart';
import '../../repositories/transfers_repository.dart';

class CreateTransferUseCase {
  final TransfersRepository repository;

  CreateTransferUseCase(this.repository);

  Future<Transfer> call(Transfer transfer) async {
    return await repository.createTransfer(transfer);
  }
}
