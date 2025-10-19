import '../../../../core/domain/entities/store.dart';

abstract class StoresState {}

class StoresInitial extends StoresState {}

class StoresLoading extends StoresState {}

class StoresLoaded extends StoresState {
  final List<Store> stores;

  StoresLoaded(this.stores);
}

class StoresError extends StoresState {
  final String message;

  StoresError(this.message);
}
