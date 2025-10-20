import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/reports/generate_sales_report_usecase.dart';
import '../../../../core/domain/usercases/reports/generate_purchases_report_usecase.dart';
import '../../../../core/domain/usercases/reports/generate_transfers_report_usecase.dart';
import '../../../../core/domain/usercases/reports/generate_daily_sales_report_usecase.dart';
import '../../../../core/domain/usercases/reports/get_report_history_usecase.dart';
import 'reports_event.dart';
import 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GenerateSalesReportUseCase generateSalesReportUseCase;
  final GeneratePurchasesReportUseCase generatePurchasesReportUseCase;
  final GenerateTransfersReportUseCase generateTransfersReportUseCase;
  final GenerateDailySalesReportUseCase generateDailySalesReportUseCase;
  final GetReportHistoryUseCase getReportHistoryUseCase;

  ReportsBloc({
    required this.generateSalesReportUseCase,
    required this.generatePurchasesReportUseCase,
    required this.generateTransfersReportUseCase,
    required this.generateDailySalesReportUseCase,
    required this.getReportHistoryUseCase,
  }) : super(ReportsInitial()) {
    on<LoadReportsEvent>(_onLoadReports);
    on<GenerateSalesReportEvent>(_onGenerateSalesReport);
    on<GeneratePurchasesReportEvent>(_onGeneratePurchasesReport);
    on<GenerateTransfersReportEvent>(_onGenerateTransfersReport);
    on<GenerateDailySalesReportEvent>(_onGenerateDailySalesReport);
    on<ViewReportEvent>(_onViewReport);
  }

  Future<void> _onLoadReports(
    LoadReportsEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      final reports = await getReportHistoryUseCase();
      emit(ReportsLoaded(reports));
    } catch (e) {
      emit(ReportsError('Error al cargar reportes: $e'));
    }
  }

  Future<void> _onGenerateSalesReport(
    GenerateSalesReportEvent event,
    Emitter<ReportsState> emit,
  ) async {
    print('🔄 BLoC: Iniciando generación de reporte de ventas...');
    emit(ReportsLoading());
    try {
      final report = await generateSalesReportUseCase(
        storeId: event.storeId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      print('✅ BLoC: Reporte generado exitosamente, emitiendo ReportGenerated');
      emit(ReportGenerated(report));
    } catch (e) {
      print('❌ BLoC: Error al generar reporte: $e');
      emit(ReportsError('Error al generar reporte de ventas: $e'));
    }
  }

  Future<void> _onGeneratePurchasesReport(
    GeneratePurchasesReportEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      final report = await generatePurchasesReportUseCase(
        storeId: event.storeId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(ReportGenerated(report));
    } catch (e) {
      emit(ReportsError('Error al generar reporte de compras: $e'));
    }
  }

  Future<void> _onGenerateTransfersReport(
    GenerateTransfersReportEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      final report = await generateTransfersReportUseCase(
        storeId: event.storeId,
        warehouseId: event.warehouseId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(ReportGenerated(report));
    } catch (e) {
      emit(ReportsError('Error al generar reporte de transferencias: $e'));
    }
  }

  Future<void> _onGenerateDailySalesReport(
    GenerateDailySalesReportEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      final report = await generateDailySalesReportUseCase(date: event.date);
      emit(ReportGenerated(report));
    } catch (e) {
      emit(ReportsError('Error al generar reporte de ventas diarias: $e'));
    }
  }

  void _onViewReport(ViewReportEvent event, Emitter<ReportsState> emit) {
    emit(ReportGenerated(event.report));
  }
}
