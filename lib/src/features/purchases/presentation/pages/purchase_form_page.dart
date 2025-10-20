import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/domain/entities/purchase.dart';
import '../../../../core/domain/entities/product.dart';
import '../../../../core/domain/entities/employee.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../../../../core/domain/usercases/inventory/get_inventory_usecase.dart';
import '../../../../core/domain/usercases/employees/get_employees_usecase.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../../../../core/domain/usercases/warehouses/get_warehouses_usecase.dart';
import '../bloc/purchases_bloc.dart';
import '../bloc/purchases_event.dart';

class PurchaseFormPage extends StatefulWidget {
  final Purchase? purchase; // Para edición

  const PurchaseFormPage({super.key, this.purchase});

  @override
  _PurchaseFormPageState createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _supplierNameController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown values
  Product? _selectedProduct;
  Employee? _selectedEmployee;
  Store? _selectedStore;
  Warehouse? _selectedWarehouse;

  // Lists for dropdowns
  List<Product> _products = [];
  List<Employee> _employees = [];
  List<Store> _stores = [];
  List<Warehouse> _warehouses = [];

  // Loading states
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.purchase != null) {
      // Modo edición
      _quantityController.text = widget.purchase!.quantity.toString();
      _unitPriceController.text = widget.purchase!.unitPrice?.toString() ?? '';
      _totalPriceController.text =
          widget.purchase!.totalPrice?.toString() ?? '';
      _supplierNameController.text = widget.purchase!.supplierName ?? '';
      _notesController.text = widget.purchase!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    _supplierNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Load products
      final getInventoryUseCase = GetIt.instance<GetInventoryUseCase>();
      final products = await getInventoryUseCase();

      // Load employees
      final getEmployeesUseCase = GetIt.instance<GetEmployeesUseCase>();
      final employees = await getEmployeesUseCase();

      // Load stores
      final getStoresUseCase = GetIt.instance<GetStoresUseCase>();
      final stores = await getStoresUseCase();

      // Load warehouses
      final getWarehousesUseCase = GetIt.instance<GetWarehousesUseCase>();
      final warehouses = await getWarehousesUseCase();

      setState(() {
        _products = products;
        _employees = employees;
        _stores = stores;
        _warehouses = warehouses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los datos: $e';
      });
    }
  }

  void _calculateTotal() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0.0;
    final total = quantity * unitPrice;
    _totalPriceController.text = total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.purchase != null ? 'Editar Compra' : 'Nueva Compra'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _savePurchase),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
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
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
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

                            // Product Dropdown
                            DropdownButtonFormField<Product>(
                              decoration: const InputDecoration(
                                labelText: 'Producto *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.inventory),
                              ),
                              value: _selectedProduct,
                              items: _products.map((product) {
                                return DropdownMenuItem<Product>(
                                  value: product,
                                  child: Text(
                                    '${product.name} (Stock: ${product.stock})',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedProduct = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor seleccione un producto';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Quantity and Price Row
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _quantityController,
                                    decoration: const InputDecoration(
                                      labelText: 'Cantidad *',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.numbers),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => _calculateTotal(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ingrese la cantidad';
                                      }
                                      final quantity = int.tryParse(value);
                                      if (quantity == null || quantity <= 0) {
                                        return 'Cantidad debe ser mayor a 0';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _unitPriceController,
                                    decoration: const InputDecoration(
                                      labelText: 'Precio Unitario',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.attach_money),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => _calculateTotal(),
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        final price = double.tryParse(value);
                                        if (price == null || price < 0) {
                                          return 'Precio debe ser mayor o igual a 0';
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Total Price
                            TextFormField(
                              controller: _totalPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Total',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calculate),
                                filled: true,
                                fillColor: Colors.grey,
                              ),
                              keyboardType: TextInputType.number,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Información del Proveedor
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información del Proveedor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _supplierNameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del Proveedor',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.business),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Información de la Compra
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información de la Compra',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Employee Dropdown
                            DropdownButtonFormField<Employee>(
                              decoration: const InputDecoration(
                                labelText: 'Empleado *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              value: _selectedEmployee,
                              items: _employees.map((employee) {
                                return DropdownMenuItem<Employee>(
                                  value: employee,
                                  child: Text(
                                    '${employee.name} (${employee.role})',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedEmployee = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor seleccione un empleado';
                                }
                                return null;
                              },
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
                            const SizedBox(height: 16),

                            // Notes
                            TextFormField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Notas',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.note),
                                hintText: 'Observaciones adicionales...',
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton.icon(
                      onPressed: _savePurchase,
                      icon: const Icon(Icons.save),
                      label: Text(
                        widget.purchase != null
                            ? 'Actualizar Compra'
                            : 'Guardar Compra',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _savePurchase() async {
    if (_formKey.currentState!.validate() &&
        _selectedProduct != null &&
        _selectedEmployee != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final quantity = int.parse(_quantityController.text);
        final unitPrice = double.tryParse(_unitPriceController.text) ?? 0.0;
        final totalPrice = double.tryParse(_totalPriceController.text) ?? 0.0;

        final purchase = Purchase(
          id: widget.purchase?.id ?? 0,
          productId: _selectedProduct!.id,
          quantity: quantity,
          unitPrice: unitPrice > 0 ? unitPrice : null,
          totalPrice: totalPrice > 0 ? totalPrice : null,
          employeeId: _selectedEmployee!.id,
          storeId: _selectedStore?.id,
          warehouseId: _selectedWarehouse?.id,
          supplierName: _supplierNameController.text.isNotEmpty
              ? _supplierNameController.text
              : null,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
          createdAt: widget.purchase?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (mounted) {
          context.read<PurchasesBloc>().add(CreatePurchaseEvent(purchase));
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error al guardar la compra: $e';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar la compra: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
