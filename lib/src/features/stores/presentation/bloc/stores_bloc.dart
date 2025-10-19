import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../../../../core/domain/usercases/stores/add_store_usecase.dart';
import '../../../../core/domain/usercases/stores/update_store_usecase.dart';
import '../../../../core/domain/usercases/stores/delete_store_usecase.dart';
import 'stores_event.dart';
import 'stores_state.dart';

class StoresBloc extends Bloc<StoresEvent, StoresState> {
  final GetStoresUseCase getStoresUseCase;
  final AddStoreUseCase addStoreUseCase;
  final UpdateStoreUseCase updateStoreUseCase;
  final DeleteStoreUseCase deleteStoreUseCase;

  StoresBloc({
    required this.getStoresUseCase,
    required this.addStoreUseCase,
    required this.updateStoreUseCase,
    required this.deleteStoreUseCase,
  }) : super(StoresInitial()) {
    on<LoadStoresEvent>((event, emit) async {
      print('🏪 StoresBloc: Cargando tiendas...');
      emit(StoresLoading());
      try {
        final stores = await getStoresUseCase();
        print('🏪 StoresBloc: ${stores.length} tiendas cargadas');
        emit(StoresLoaded(stores));
      } catch (e) {
        print('❌ StoresBloc: Error al cargar: $e');
        emit(StoresError(e.toString()));
      }
    });

    on<AddStoreEvent>((event, emit) async {
      print('🏪 StoresBloc: Agregando tienda: ${event.store.name}');
      emit(StoresLoading());
      try {
        await addStoreUseCase(event.store);
        print('✅ StoresBloc: Tienda agregada exitosamente');
        // Recargar las tiendas
        add(LoadStoresEvent());
      } catch (e) {
        print('❌ StoresBloc: Error al agregar: $e');
        emit(StoresError(e.toString()));
      }
    });

    on<UpdateStoreEvent>((event, emit) async {
      print('🏪 StoresBloc: Actualizando tienda: ${event.store.name}');
      emit(StoresLoading());
      try {
        await updateStoreUseCase(event.store);
        print('✅ StoresBloc: Tienda actualizada exitosamente');
        // Recargar las tiendas
        add(LoadStoresEvent());
      } catch (e) {
        print('❌ StoresBloc: Error al actualizar: $e');
        emit(StoresError(e.toString()));
      }
    });

    on<DeleteStoreEvent>((event, emit) async {
      print('🏪 StoresBloc: Eliminando tienda ID: ${event.storeId}');
      emit(StoresLoading());
      try {
        await deleteStoreUseCase(event.storeId);
        print('✅ StoresBloc: Tienda eliminada exitosamente');
        // Recargar las tiendas
        add(LoadStoresEvent());
      } catch (e) {
        print('❌ StoresBloc: Error al eliminar: $e');
        emit(StoresError(e.toString()));
      }
    });
  }
}
