import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/domain/entities/sale.dart';
import '../../../../core/domain/entities/product.dart';
import '../../../../core/domain/entities/employee.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/usercases/inventory/get_inventory_usecase.dart';
import '../../../../core/domain/usercases/employees/get_employees_usecase.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../bloc/sales_bloc.dart';
import '../bloc/sales_event.dart';

class SaleDetailPage extends StatefulWidget {
  const SaleDetailPage({super.key});

  @override
  _SaleDetailPageState createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends State<SaleDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  
  // Dropdown values
  Product? _selectedProduct;
  Employee? _selectedEmployee;
  Store? _selectedStore;
  
  // Lists for dropdowns
  List<Product> _products = [];
  List<Employee> _employees = [];
  List<Store> _stores = [];
  
  // Loading states
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  @override
  void dispose() {
    _quantityController.dispose();
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
      
      setState(() {
        _products = products;
        _employees = employees;
        _stores = stores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los datos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Venta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSale,
          ),
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
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // Product Dropdown
                        DropdownButtonFormField<Product>(
                          decoration: const InputDecoration(
                            labelText: 'Producto',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedProduct,
                          items: _products.map((product) {
                            return DropdownMenuItem<Product>(
                              value: product,
                              child: Text('${product.name} (ID: ${product.id})'),
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
                        
                        // Quantity Input
                        TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la cantidad';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Por favor ingrese un número válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Employee Dropdown
                        DropdownButtonFormField<Employee>(
                          decoration: const InputDecoration(
                            labelText: 'Empleado',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedEmployee,
                          items: _employees.map((employee) {
                            return DropdownMenuItem<Employee>(
                              value: employee,
                              child: Text('${employee.name} (ID: ${employee.id})'),
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
                        
                        // Store Dropdown (Optional)
                        DropdownButtonFormField<Store>(
                          decoration: const InputDecoration(
                            labelText: 'Tienda (Opcional)',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedStore,
                          items: [
                            const DropdownMenuItem<Store>(
                              value: null,
                              child: Text('Ninguna tienda seleccionada'),
                            ),
                            ..._stores.map((store) {
                              return DropdownMenuItem<Store>(
                                value: store,
                                child: Text('${store.name} (ID: ${store.id})'),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStore = value;
                            });
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSale() async {
    if (_formKey.currentState!.validate() && 
        _selectedProduct != null && 
        _selectedEmployee != null) {
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      try {
        final sale = Sale(
          id: 0, // Will be set by the database
          productId: _selectedProduct!.id,
          quantity: int.parse(_quantityController.text),
          employeeId: _selectedEmployee!.id,
          storeId: _selectedStore?.id,
          warehouseId: 1, // Set a default warehouse ID
          createdAt: DateTime.now(),
        );
        
        if (mounted) {
          context.read<SalesBloc>().add(CreateSaleEvent(sale));
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error al guardar la venta: $e';
          });
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar la venta: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
