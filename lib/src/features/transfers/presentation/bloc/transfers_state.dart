import '../../../../core/domain/entities/transfer.dart';

abstract class TransfersState {}

class TransfersInitial extends TransfersState {}

class TransfersLoading extends TransfersState {}

class TransfersLoaded extends TransfersState {
  final List<Transfer> transfers;

  TransfersLoaded(this.transfers);
}

class TransfersError extends TransfersState {
  final String message;

  TransfersError(this.message);
}
