import '../../../../core/domain/entities/warehouse.dart';

abstract class WarehousesEvent {}

class LoadWarehousesEvent extends WarehousesEvent {}

class AddWarehouseEvent extends WarehousesEvent {
  final Warehouse warehouse;

  AddWarehouseEvent(this.warehouse);
}

class UpdateWarehouseEvent extends WarehousesEvent {
  final Warehouse warehouse;

  UpdateWarehouseEvent(this.warehouse);
}

class DeleteWarehouseEvent extends WarehousesEvent {
  final int warehouseId;

  DeleteWarehouseEvent(this.warehouseId);
}
