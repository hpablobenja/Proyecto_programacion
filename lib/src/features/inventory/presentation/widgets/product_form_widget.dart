import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/domain/entities/product.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../../../../core/domain/usercases/warehouses/get_warehouses_usecase.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';

class ProductFormWidget extends StatefulWidget {
  final Product? product;

  const ProductFormWidget({super.key, this.product});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController variantController;
  late final TextEditingController stockController;
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  Store? _selectedStore;
  Warehouse? _selectedWarehouse;

  // Lists for dropdowns
  List<Store> _stores = [];
  List<Warehouse> _warehouses = [];

  // Loading states
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name);
    variantController = TextEditingController(text: widget.product?.variant);
    stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '0',
    );
    _loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    variantController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Load stores
      final getStoresUseCase = GetIt.instance<GetStoresUseCase>();
      final stores = await getStoresUseCase();

      // Load warehouses
      final getWarehousesUseCase = GetIt.instance<GetWarehousesUseCase>();
      final warehouses = await getWarehousesUseCase();

      setState(() {
        _stores = stores;
        _warehouses = warehouses;
        _isLoading = false;
      });

      // Set initial values if editing
      if (widget.product != null) {
        _selectedStore = _stores.firstWhere(
          (store) => store.id == widget.product!.storeId,
          orElse: () => _stores.first,
        );
        _selectedWarehouse = _warehouses.firstWhere(
          (warehouse) => warehouse.id == widget.product!.warehouseId,
          orElse: () => _warehouses.first,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los datos: $e';
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? 0, // 0 para nuevo producto
        name: nameController.text.trim(),
        variant: variantController.text.trim().isEmpty
            ? null
            : variantController.text.trim(),
        stock: int.tryParse(stockController.text) ?? 0,
        storeId: _selectedStore?.id,
        warehouseId: _selectedWarehouse?.id,
        updatedAt: DateTime.now(),
      );

      print('💾 Guardando producto: ${newProduct.name}');

      if (widget.product == null) {
        // Agregar nuevo producto
        context.read<InventoryBloc>().add(AddProductEvent(newProduct));
      } else {
        // Actualizar producto existente
        context.read<InventoryBloc>().add(UpdateProductEvent(newProduct));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información del Producto
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información del Producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Producto *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingrese el nombre del producto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: variantController,
                      decoration: const InputDecoration(
                        labelText: 'Variante (Opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: stockController,
                      decoration: const InputDecoration(
                        labelText: 'Stock *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingrese la cantidad en stock';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor ingrese un número válido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ubicación del Producto
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ubicación del Producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Store Dropdown
                    DropdownButtonFormField<Store>(
                      decoration: const InputDecoration(
                        labelText: 'Tienda',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.store),
                      ),
                      value: _selectedStore,
                      items: [
                        const DropdownMenuItem<Store>(
                          value: null,
                          child: Text('Sin tienda específica'),
                        ),
                        ..._stores.map((store) {
                          return DropdownMenuItem<Store>(
                            value: store,
                            child: Text(store.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStore = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Warehouse Dropdown
                    DropdownButtonFormField<Warehouse>(
                      decoration: const InputDecoration(
                        labelText: 'Almacén',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.warehouse),
                      ),
                      value: _selectedWarehouse,
                      items: [
                        const DropdownMenuItem<Warehouse>(
                          value: null,
                          child: Text('Sin almacén específico'),
                        ),
                        ..._warehouses.map((warehouse) {
                          return DropdownMenuItem<Warehouse>(
                            value: warehouse,
                            child: Text(warehouse.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedWarehouse = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveProduct,
              icon: const Icon(Icons.save),
              label: Text(
                widget.product == null
                    ? 'Agregar Producto'
                    : 'Actualizar Producto',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
