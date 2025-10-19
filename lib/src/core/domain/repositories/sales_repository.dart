import '../entities/sale.dart';

abstract class SalesRepository {
  Future<List<Sale>> getSales(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  );
  
  /// Creates a new sale and returns the created sale with the generated ID
  Future<Sale> createSale(Sale sale);
  
  Future<void> generateReceipt(int saleId);
}
