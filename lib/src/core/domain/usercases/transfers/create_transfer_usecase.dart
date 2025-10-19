import '../../entities/transfer.dart';
import '../../repositories/transfers_repository.dart';

class CreateTransferUseCase {
  final TransfersRepository repository;

  CreateTransferUseCase(this.repository);

  Future<void> call(Transfer transfer) async {
    await repository.createTransfer(transfer);
  }
}
