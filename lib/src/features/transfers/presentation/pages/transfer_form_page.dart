import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/domain/entities/transfer.dart';
import '../../../../core/domain/entities/product.dart';
import '../../../../core/domain/entities/employee.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../../../../core/domain/usercases/inventory/get_inventory_usecase.dart';
import '../../../../core/domain/usercases/employees/get_employees_usecase.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../../../../core/domain/usercases/warehouses/get_warehouses_usecase.dart';
import '../bloc/transfers_bloc.dart';
import '../bloc/transfers_event.dart';

class TransferFormPage extends StatefulWidget {
  final Transfer? transfer; // Para edición

  const TransferFormPage({super.key, this.transfer});

  @override
  _TransferFormPageState createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown values
  Product? _selectedProduct;
  Employee? _selectedEmployee;
  String _fromLocationType = 'warehouse';
  String _toLocationType = 'store';
  Store? _selectedFromStore;
  Warehouse? _selectedFromWarehouse;
  Store? _selectedToStore;
  Warehouse? _selectedToWarehouse;

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
    if (widget.transfer != null) {
      // Modo edición
      _quantityController.text = widget.transfer!.quantity.toString();
      _notesController.text = widget.transfer!.notes ?? '';
      _fromLocationType = widget.transfer!.fromLocationType;
      _toLocationType = widget.transfer!.toLocationType;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transfer != null
              ? 'Editar Transferencia'
              : 'Nueva Transferencia',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveTransfer),
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

                            // Quantity
                            TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                labelText: 'Cantidad *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese la cantidad';
                                }
                                final quantity = int.tryParse(value);
                                if (quantity == null || quantity <= 0) {
                                  return 'Cantidad debe ser mayor a 0';
                                }
                                if (_selectedProduct != null &&
                                    quantity > _selectedProduct!.stock) {
                                  return 'Cantidad excede el stock disponible';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ubicación de Origen
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ubicación de Origen',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // From Location Type
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Ubicación *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              value: _fromLocationType,
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'store',
                                  child: Text('Tienda'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'warehouse',
                                  child: Text('Almacén'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _fromLocationType = value!;
                                  _selectedFromStore = null;
                                  _selectedFromWarehouse = null;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // From Location Selection
                            if (_fromLocationType == 'store')
                              DropdownButtonFormField<Store>(
                                decoration: const InputDecoration(
                                  labelText: 'Tienda de Origen *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.store),
                                ),
                                value: _selectedFromStore,
                                items: _stores.map((store) {
                                  return DropdownMenuItem<Store>(
                                    value: store,
                                    child: Text(store.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFromStore = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleccione una tienda de origen';
                                  }
                                  return null;
                                },
                              )
                            else
                              DropdownButtonFormField<Warehouse>(
                                decoration: const InputDecoration(
                                  labelText: 'Almacén de Origen *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.warehouse),
                                ),
                                value: _selectedFromWarehouse,
                                items: _warehouses.map((warehouse) {
                                  return DropdownMenuItem<Warehouse>(
                                    value: warehouse,
                                    child: Text(warehouse.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFromWarehouse = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleccione un almacén de origen';
                                  }
                                  return null;
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ubicación de Destino
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ubicación de Destino',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // To Location Type
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Ubicación *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              value: _toLocationType,
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'store',
                                  child: Text('Tienda'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'warehouse',
                                  child: Text('Almacén'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _toLocationType = value!;
                                  _selectedToStore = null;
                                  _selectedToWarehouse = null;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // To Location Selection
                            if (_toLocationType == 'store')
                              DropdownButtonFormField<Store>(
                                decoration: const InputDecoration(
                                  labelText: 'Tienda de Destino *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.store),
                                ),
                                value: _selectedToStore,
                                items: _stores.map((store) {
                                  return DropdownMenuItem<Store>(
                                    value: store,
                                    child: Text(store.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedToStore = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleccione una tienda de destino';
                                  }
                                  return null;
                                },
                              )
                            else
                              DropdownButtonFormField<Warehouse>(
                                decoration: const InputDecoration(
                                  labelText: 'Almacén de Destino *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.warehouse),
                                ),
                                value: _selectedToWarehouse,
                                items: _warehouses.map((warehouse) {
                                  return DropdownMenuItem<Warehouse>(
                                    value: warehouse,
                                    child: Text(warehouse.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedToWarehouse = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleccione un almacén de destino';
                                  }
                                  return null;
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Información de la Transferencia
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Información de la Transferencia',
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
                      onPressed: _saveTransfer,
                      icon: const Icon(Icons.save),
                      label: Text(
                        widget.transfer != null
                            ? 'Actualizar Transferencia'
                            : 'Crear Transferencia',
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

  Future<void> _saveTransfer() async {
    if (_formKey.currentState!.validate() &&
        _selectedProduct != null &&
        _selectedEmployee != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final quantity = int.parse(_quantityController.text);

        final transfer = Transfer(
          id: widget.transfer?.id ?? 0,
          productId: _selectedProduct!.id,
          quantity: quantity,
          employeeId: _selectedEmployee!.id,
          fromLocationType: _fromLocationType,
          fromLocationId: _fromLocationType == 'store'
              ? _selectedFromStore!.id
              : _selectedFromWarehouse!.id,
          toLocationType: _toLocationType,
          toLocationId: _toLocationType == 'store'
              ? _selectedToStore!.id
              : _selectedToWarehouse!.id,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
          createdAt: widget.transfer?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (mounted) {
          context.read<TransfersBloc>().add(CreateTransferEvent(transfer));
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error al guardar la transferencia: $e';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar la transferencia: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
