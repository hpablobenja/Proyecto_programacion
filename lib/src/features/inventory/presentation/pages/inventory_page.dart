import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';
import '../widgets/product_list_widget.dart';
import '../widgets/inventory_filters_widget.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int? _filteredStoreId;
  int? _filteredWarehouseId;

  @override
  void initState() {
    super.initState();
    // Cargar inventario al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryBloc>().add(LoadInventoryEvent(null, null));
    });
  }

  void _onFilterChanged(int? storeId, int? warehouseId) {
    setState(() {
      _filteredStoreId = storeId;
      _filteredWarehouseId = warehouseId;
    });

    // Recargar inventario con filtros
    context.read<InventoryBloc>().add(LoadInventoryEvent(storeId, warehouseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InventoryBloc>().add(LoadInventoryEvent(null, null));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          InventoryFiltersWidget(onFilterChanged: _onFilterChanged),
          Expanded(
            child: BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InventoryLoaded) {
                  // Filtrar productos según los filtros seleccionados
                  final filteredProducts = state.products.where((product) {
                    if (_filteredStoreId != null &&
                        product.storeId != _filteredStoreId) {
                      return false;
                    }
                    if (_filteredWarehouseId != null &&
                        product.warehouseId != _filteredWarehouseId) {
                      return false;
                    }
                    return true;
                  }).toList();

                  return ProductListWidget(products: filteredProducts);
                } else if (state is InventoryError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<InventoryBloc>().add(
                              LoadInventoryEvent(null, null),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('Cargando inventario...'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/product_detail'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
