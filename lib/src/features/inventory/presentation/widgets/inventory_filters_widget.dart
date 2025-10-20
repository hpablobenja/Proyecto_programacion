import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../../../../core/domain/usercases/warehouses/get_warehouses_usecase.dart';

class InventoryFiltersWidget extends StatefulWidget {
  final Function(int? storeId, int? warehouseId) onFilterChanged;

  const InventoryFiltersWidget({super.key, required this.onFilterChanged});

  @override
  State<InventoryFiltersWidget> createState() => _InventoryFiltersWidgetState();
}

class _InventoryFiltersWidgetState extends State<InventoryFiltersWidget> {
  Store? _selectedStore;
  Warehouse? _selectedWarehouse;
  List<Store> _stores = [];
  List<Warehouse> _warehouses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final getStoresUseCase = GetIt.instance<GetStoresUseCase>();
      final stores = await getStoresUseCase();

      final getWarehousesUseCase = GetIt.instance<GetWarehousesUseCase>();
      final warehouses = await getWarehousesUseCase();

      setState(() {
        _stores = stores;
        _warehouses = warehouses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    widget.onFilterChanged(_selectedStore?.id, _selectedWarehouse?.id);
  }

  void _clearFilters() {
    setState(() {
      _selectedStore = null;
      _selectedWarehouse = null;
    });
    widget.onFilterChanged(null, null);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Filtros de Inventario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Store>(
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por Tienda',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.store),
                    ),
                    value: _selectedStore,
                    items: [
                      const DropdownMenuItem<Store>(
                        value: null,
                        child: Text('Todas las tiendas'),
                      ),
                      ..._stores.map((store) {
                        return DropdownMenuItem<Store>(
                          value: store,
                          child: Text(
                            store.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStore = value;
                      });
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Warehouse>(
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por Almacén',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.warehouse),
                    ),
                    value: _selectedWarehouse,
                    items: [
                      const DropdownMenuItem<Warehouse>(
                        value: null,
                        child: Text('Todos los almacenes'),
                      ),
                      ..._warehouses.map((warehouse) {
                        return DropdownMenuItem<Warehouse>(
                          value: warehouse,
                          child: Text(
                            warehouse.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedWarehouse = value;
                      });
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedStore != null || _selectedWarehouse != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getFilterDescription(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFilterDescription() {
    if (_selectedStore != null && _selectedWarehouse != null) {
      return 'Mostrando productos de ${_selectedStore!.name} y ${_selectedWarehouse!.name}';
    } else if (_selectedStore != null) {
      return 'Mostrando productos de la tienda ${_selectedStore!.name}';
    } else if (_selectedWarehouse != null) {
      return 'Mostrando productos del almacén ${_selectedWarehouse!.name}';
    }
    return 'Mostrando todos los productos';
  }
}
