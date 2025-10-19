import '../../../../core/domain/entities/product.dart';

abstract class InventoryEvent {}

class LoadInventoryEvent extends InventoryEvent {
  final int? storeId;
  final int? warehouseId;

  LoadInventoryEvent(this.storeId, this.warehouseId);
}

class AddProductEvent extends InventoryEvent {
  final Product product;

  AddProductEvent(this.product);
}

class UpdateProductEvent extends InventoryEvent {
  final Product product;

  UpdateProductEvent(this.product);
}

class DeleteProductEvent extends InventoryEvent {
  final int productId;

  DeleteProductEvent(this.productId);
}
