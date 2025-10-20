import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/purchases/create_purchase_usecase.dart';
import '../../../../core/domain/usercases/purchases/get_purchases_usecase.dart';
import 'purchases_event.dart';
import 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  final GetPurchasesUseCase getPurchasesUseCase;
  final CreatePurchaseUseCase createPurchaseUseCase;

  PurchasesBloc({
    required this.getPurchasesUseCase,
    required this.createPurchaseUseCase,
  }) : super(PurchasesInitial()) {
    on<LoadPurchasesEvent>(_onLoadPurchases);
    on<CreatePurchaseEvent>(_onCreatePurchase);
  }

  Future<void> _onLoadPurchases(
    LoadPurchasesEvent event,
    Emitter<PurchasesState> emit,
  ) async {
    emit(PurchasesLoading());
    try {
      final purchases = await getPurchasesUseCase(
        event.storeId,
        event.warehouseId,
        event.startDate,
        event.endDate,
      );
      emit(PurchasesLoaded(purchases));
    } catch (e) {
      emit(PurchasesError(e.toString()));
    }
  }

  Future<void> _onCreatePurchase(
    CreatePurchaseEvent event,
    Emitter<PurchasesState> emit,
  ) async {
    emit(PurchasesLoading());
    try {
      await createPurchaseUseCase(event.purchase);
      emit(PurchasesSuccess());
      // Reload purchases after successful creation
      final purchases = await getPurchasesUseCase(null, null, null, null);
      emit(PurchasesLoaded(purchases));
    } catch (e) {
      emit(PurchasesError(e.toString()));
    }
  }
}
