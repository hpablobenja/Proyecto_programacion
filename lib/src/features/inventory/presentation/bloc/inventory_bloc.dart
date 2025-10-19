import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/inventory/get_inventory_usecase.dart';
import '../../../../core/domain/usercases/inventory/add_product_usecase.dart';
import '../../../../core/domain/usercases/inventory/update_product_usecase.dart';
import '../../../../core/domain/usercases/inventory/delete_product_usecase.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventoryUseCase getInventoryUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  InventoryBloc({
    required this.getInventoryUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(InventoryInitial()) {
    on<LoadInventoryEvent>((event, emit) async {
      print('📦 InventoryBloc: Cargando inventario...');
      emit(InventoryLoading());
      try {
        final products = await getInventoryUseCase(
          storeId: event.storeId,
          warehouseId: event.warehouseId,
        );
        print('📦 InventoryBloc: ${products.length} productos cargados');
        emit(InventoryLoaded(products));
      } catch (e) {
        print('❌ InventoryBloc: Error al cargar: $e');
        emit(InventoryError(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      print('📦 InventoryBloc: Agregando producto: ${event.product.name}');
      emit(InventoryLoading());
      try {
        await addProductUseCase(event.product);
        print('✅ InventoryBloc: Producto agregado exitosamente');
        // Recargar el inventario
        add(LoadInventoryEvent(null, null));
      } catch (e) {
        print('❌ InventoryBloc: Error al agregar: $e');
        emit(InventoryError(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      print('📦 InventoryBloc: Actualizando producto: ${event.product.name}');
      emit(InventoryLoading());
      try {
        await updateProductUseCase(event.product);
        print('✅ InventoryBloc: Producto actualizado exitosamente');
        // Recargar el inventario
        add(LoadInventoryEvent(null, null));
      } catch (e) {
        print('❌ InventoryBloc: Error al actualizar: $e');
        emit(InventoryError(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      print('📦 InventoryBloc: Eliminando producto ID: ${event.productId}');
      emit(InventoryLoading());
      try {
        await deleteProductUseCase(event.productId);
        print('✅ InventoryBloc: Producto eliminado exitosamente');
        // Recargar el inventario
        add(LoadInventoryEvent(null, null));
      } catch (e) {
        print('❌ InventoryBloc: Error al eliminar: $e');
        emit(InventoryError(e.toString()));
      }
    });
  }
}
