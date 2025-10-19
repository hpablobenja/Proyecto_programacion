import '../../../../core/domain/entities/sale.dart';

abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<Sale> sales;

  SalesLoaded(this.sales);
}

class SalesSuccess extends SalesState {}

class SalesError extends SalesState {
  final String message;

  SalesError(this.message);
}
