import '../../../../core/domain/entities/store.dart';

abstract class StoresEvent {}

class LoadStoresEvent extends StoresEvent {}

class AddStoreEvent extends StoresEvent {
  final Store store;

  AddStoreEvent(this.store);
}

class UpdateStoreEvent extends StoresEvent {
  final Store store;

  UpdateStoreEvent(this.store);
}

class DeleteStoreEvent extends StoresEvent {
  final int storeId;

  DeleteStoreEvent(this.storeId);
}
