import '../../../../core/domain/entities/purchase.dart';

abstract class PurchasesState {}

class PurchasesInitial extends PurchasesState {}

class PurchasesLoading extends PurchasesState {}

class PurchasesLoaded extends PurchasesState {
  final List<Purchase> purchases;

  PurchasesLoaded(this.purchases);
}

class PurchasesSuccess extends PurchasesState {}

class PurchasesError extends PurchasesState {
  final String message;

  PurchasesError(this.message);
}
