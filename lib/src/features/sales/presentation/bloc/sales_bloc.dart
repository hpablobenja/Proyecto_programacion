import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/sales/create_sale_usecase.dart';
import '../../../../core/domain/usercases/sales/get_sales_usecase.dart';
import 'sales_event.dart';
import 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final GetSalesUseCase getSalesUseCase;
  final CreateSaleUseCase createSaleUseCase;

  SalesBloc({required this.getSalesUseCase, required this.createSaleUseCase})
    : super(SalesInitial()) {
    on<LoadSalesEvent>((event, emit) async {
      emit(SalesLoading());
      try {
        final sales = await getSalesUseCase(
          event.storeId,
          event.startDate,
          event.endDate,
        );
        emit(SalesLoaded(sales));
      } catch (e) {
        emit(SalesError(e.toString()));
      }
    });

    on<CreateSaleEvent>((event, emit) async {
      emit(SalesLoading());
      try {
        await createSaleUseCase(event.sale);
        emit(SalesSuccess());
      } catch (e) {
        emit(SalesError(e.toString()));
      }
    });
  }
}
