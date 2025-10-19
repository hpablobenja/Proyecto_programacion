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
    on<LoadPurchasesEvent>((event, emit) async {
      emit(PurchasesLoading());
      try {
        final purchases = await getPurchasesUseCase(
          event.storeId,
          event.startDate,
          event.endDate,
        );
        emit(PurchasesLoaded(purchases));
      } catch (e) {
        emit(PurchasesError(e.toString()));
      }
    });

    on<CreatePurchaseEvent>((event, emit) async {
      emit(PurchasesLoading());
      try {
        await createPurchaseUseCase(event.purchase);
        emit(PurchasesLoaded([]));
      } catch (e) {
        emit(PurchasesError(e.toString()));
      }
    });
  }
}
