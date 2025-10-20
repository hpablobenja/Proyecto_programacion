import '../../../../core/domain/entities/transfer.dart';

abstract class TransfersEvent {}

class LoadTransfersEvent extends TransfersEvent {
  final int? storeId;
  final int? warehouseId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadTransfersEvent({
    this.storeId,
    this.warehouseId,
    this.startDate,
    this.endDate,
  });
}

class CreateTransferEvent extends TransfersEvent {
  final Transfer transfer;

  CreateTransferEvent(this.transfer);
}
