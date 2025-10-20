import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/transfers/create_transfer_usecase.dart';
import '../../../../core/domain/usercases/transfers/get_transfers_usecase.dart';
import 'transfers_event.dart';
import 'transfers_state.dart';

class TransfersBloc extends Bloc<TransfersEvent, TransfersState> {
  final GetTransfersUseCase getTransfersUseCase;
  final CreateTransferUseCase createTransferUseCase;

  TransfersBloc({
    required this.getTransfersUseCase,
    required this.createTransferUseCase,
  }) : super(TransfersInitial()) {
    on<LoadTransfersEvent>(_onLoadTransfers);
    on<CreateTransferEvent>(_onCreateTransfer);
  }

  Future<void> _onLoadTransfers(
    LoadTransfersEvent event,
    Emitter<TransfersState> emit,
  ) async {
    emit(TransfersLoading());
    try {
      final transfers = await getTransfersUseCase(
        event.storeId,
        event.warehouseId,
        event.startDate,
        event.endDate,
      );
      emit(TransfersLoaded(transfers));
    } catch (e) {
      emit(TransfersError(e.toString()));
    }
  }

  Future<void> _onCreateTransfer(
    CreateTransferEvent event,
    Emitter<TransfersState> emit,
  ) async {
    emit(TransfersLoading());
    try {
      await createTransferUseCase(event.transfer);
      emit(TransfersSuccess());
      // Reload transfers after successful creation
      final transfers = await getTransfersUseCase(null, null, null, null);
      emit(TransfersLoaded(transfers));
    } catch (e) {
      emit(TransfersError(e.toString()));
    }
  }
}
