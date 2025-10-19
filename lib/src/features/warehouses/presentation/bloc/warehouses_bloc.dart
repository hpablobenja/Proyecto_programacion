import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/warehouses/get_warehouses_usecase.dart';
import '../../../../core/domain/usercases/warehouses/add_warehouse_usecase.dart';
import '../../../../core/domain/usercases/warehouses/update_warehouse_usecase.dart';
import '../../../../core/domain/usercases/warehouses/delete_warehouse_usecase.dart';
import 'warehouses_event.dart';
import 'warehouses_state.dart';

class WarehousesBloc extends Bloc<WarehousesEvent, WarehousesState> {
  final GetWarehousesUseCase getWarehousesUseCase;
  final AddWarehouseUseCase addWarehouseUseCase;
  final UpdateWarehouseUseCase updateWarehouseUseCase;
  final DeleteWarehouseUseCase deleteWarehouseUseCase;

  WarehousesBloc({
    required this.getWarehousesUseCase,
    required this.addWarehouseUseCase,
    required this.updateWarehouseUseCase,
    required this.deleteWarehouseUseCase,
  }) : super(WarehousesInitial()) {
    on<LoadWarehousesEvent>((event, emit) async {
      print('🏢 WarehousesBloc: Cargando almacenes...');
      emit(WarehousesLoading());
      try {
        final warehouses = await getWarehousesUseCase();
        print('🏢 WarehousesBloc: ${warehouses.length} almacenes cargados');
        emit(WarehousesLoaded(warehouses));
      } catch (e) {
        print('❌ WarehousesBloc: Error al cargar: $e');
        emit(WarehousesError(e.toString()));
      }
    });

    on<AddWarehouseEvent>((event, emit) async {
      print('🏢 WarehousesBloc: Agregando almacén: ${event.warehouse.name}');
      emit(WarehousesLoading());
      try {
        await addWarehouseUseCase(event.warehouse);
        print('✅ WarehousesBloc: Almacén agregado exitosamente');
        add(LoadWarehousesEvent());
      } catch (e) {
        print('❌ WarehousesBloc: Error al agregar: $e');
        emit(WarehousesError(e.toString()));
      }
    });

    on<UpdateWarehouseEvent>((event, emit) async {
      print('🏢 WarehousesBloc: Actualizando almacén: ${event.warehouse.name}');
      emit(WarehousesLoading());
      try {
        await updateWarehouseUseCase(event.warehouse);
        print('✅ WarehousesBloc: Almacén actualizado exitosamente');
        add(LoadWarehousesEvent());
      } catch (e) {
        print('❌ WarehousesBloc: Error al actualizar: $e');
        emit(WarehousesError(e.toString()));
      }
    });

    on<DeleteWarehouseEvent>((event, emit) async {
      print('🏢 WarehousesBloc: Eliminando almacén ID: ${event.warehouseId}');
      emit(WarehousesLoading());
      try {
        await deleteWarehouseUseCase(event.warehouseId);
        print('✅ WarehousesBloc: Almacén eliminado exitosamente');
        add(LoadWarehousesEvent());
      } catch (e) {
        print('❌ WarehousesBloc: Error al eliminar: $e');
        emit(WarehousesError(e.toString()));
      }
    });
  }
}
