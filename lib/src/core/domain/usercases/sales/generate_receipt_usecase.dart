import '../../repositories/sales_repository.dart';

class GenerateReceiptUseCase {
  final SalesRepository repository;

  GenerateReceiptUseCase(this.repository);

  Future<void> call(int saleId) async {
    await repository.generateReceipt(saleId);
  }
}
