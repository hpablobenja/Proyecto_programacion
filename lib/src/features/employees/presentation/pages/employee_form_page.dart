import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entities/employee.dart';
import '../bloc/employees_bloc.dart';
import '../bloc/employees_event.dart';
import '../bloc/employees_state.dart';

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedRole = 'employee';
  int? _selectedStoreId;
  int? _selectedWarehouseId;

  final List<String> _roles = ['admin', 'manager', 'employee'];
  final List<Map<String, dynamic>> _stores = [
    {'id': 1, 'name': 'Tienda Centro'},
    {'id': 2, 'name': 'Tienda Norte'},
    {'id': 3, 'name': 'Tienda Sur'},
  ];
  final List<Map<String, dynamic>> _warehouses = [
    {'id': 1, 'name': 'Almacén Principal'},
    {'id': 2, 'name': 'Almacén Secundario'},
    {'id': 3, 'name': 'Almacén Auxiliar'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _emailController.text = widget.employee!.email;
      _phoneController.text = widget.employee!.phone ?? '';
      _addressController.text = widget.employee!.address ?? '';
      _selectedRole = widget.employee!.role;
      _selectedStoreId = widget.employee!.storeId;
      _selectedWarehouseId = widget.employee!.warehouseId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.employee == null ? 'Nuevo Empleado' : 'Editar Empleado',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveEmployee),
        ],
      ),
      body: BlocConsumer<EmployeesBloc, EmployeesState>(
        listener: (context, state) {
          if (state is EmployeesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is EmployeeCreated || state is EmployeeUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.employee == null
                      ? 'Empleado creado exitosamente'
                      : 'Empleado actualizado exitosamente',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El email es requerido';
                      }
                      if (!value.contains('@')) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Teléfono
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono (Opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Dirección
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección (Opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  // Rol
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tienda
                  DropdownButtonFormField<int?>(
                    value: _selectedStoreId,
                    decoration: const InputDecoration(
                      labelText: 'Tienda (Opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.store),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Sin asignar'),
                      ),
                      ..._stores.map((store) {
                        return DropdownMenuItem<int?>(
                          value: store['id'],
                          child: Text(store['name']),
                        );
                      }),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedStoreId = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Almacén
                  DropdownButtonFormField<int?>(
                    value: _selectedWarehouseId,
                    decoration: const InputDecoration(
                      labelText: 'Almacén (Opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.warehouse),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Sin asignar'),
                      ),
                      ..._warehouses.map((warehouse) {
                        return DropdownMenuItem<int?>(
                          value: warehouse['id'],
                          child: Text(warehouse['name']),
                        );
                      }),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedWarehouseId = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveEmployee,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            widget.employee == null
                                ? 'Crear Empleado'
                                : 'Actualizar Empleado',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: widget.employee?.id ?? 0,
        name: _nameController.text,
        email: _emailController.text,
        role: _selectedRole,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        address: _addressController.text.isNotEmpty
            ? _addressController.text
            : null,
        storeId: _selectedStoreId,
        warehouseId: _selectedWarehouseId,
        createdAt: widget.employee?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.employee == null) {
        context.read<EmployeesBloc>().add(CreateEmployeeEvent(employee));
      } else {
        context.read<EmployeesBloc>().add(UpdateEmployeeEvent(employee));
      }
    }
  }
}
