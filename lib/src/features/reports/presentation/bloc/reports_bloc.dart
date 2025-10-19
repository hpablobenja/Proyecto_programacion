import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/reports/get_sales_report_usecase.dart';
import '../../../../core/domain/usercases/reports/get_purchases_report_usecase.dart';
import '../../../../core/domain/usercases/reports/get_daily_global_sales_usecase.dart';
import 'reports_event.dart';
import 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetSalesReportUseCase getSalesReportUseCase;
  final GetPurchasesReportUseCase getPurchasesReportUseCase;
  final GetDailyGlobalSalesUseCase getDailyGlobalSalesUseCase;

  ReportsBloc({
    required this.getSalesReportUseCase,
    required this.getPurchasesReportUseCase,
    required this.getDailyGlobalSalesUseCase,
  }) : super(ReportsInitial()) {
    on<LoadSalesReportEvent>((event, emit) async {
      emit(ReportsLoading());
      try {
        final sales = await getSalesReportUseCase(
          event.storeId,
          event.startDate,
          event.endDate,
        );
        emit(SalesReportLoaded(sales));
      } catch (e) {
        emit(ReportsError(e.toString()));
      }
    });

    on<LoadPurchasesReportEvent>((event, emit) async {
      emit(ReportsLoading());
      try {
        final purchases = await getPurchasesReportUseCase(
          event.storeId,
          event.startDate,
          event.endDate,
        );
        emit(PurchasesReportLoaded(purchases));
      } catch (e) {
        emit(ReportsError(e.toString()));
      }
    });

    on<LoadDailyGlobalSalesEvent>((event, emit) async {
      emit(ReportsLoading());
      try {
        final total = await getDailyGlobalSalesUseCase(event.date);
        emit(DailyGlobalSalesLoaded(total));
      } catch (e) {
        emit(ReportsError(e.toString()));
      }
    });
  }
}
