import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employees_bloc.dart';
import '../bloc/employees_event.dart';
import '../bloc/employees_state.dart';
import 'employee_form_page.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  void initState() {
    super.initState();
    // Cargar empleados al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeesBloc>().add(LoadEmployeesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EmployeesBloc>().add(LoadEmployeesEvent());
            },
          ),
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
          } else if (state is EmployeeCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empleado creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar la lista
            context.read<EmployeesBloc>().add(LoadEmployeesEvent());
          } else if (state is EmployeeUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empleado actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar la lista
            context.read<EmployeesBloc>().add(LoadEmployeesEvent());
          } else if (state is EmployeeDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empleado eliminado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar la lista
            context.read<EmployeesBloc>().add(LoadEmployeesEvent());
          }
        },
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeesLoaded) {
            final employees = state.employees;

            if (employees.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay empleados registrados',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agrega tu primer empleado',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRoleColor(employee.role),
                      child: Icon(
                        _getRoleIcon(employee.role),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      employee.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${employee.email}'),
                        Text('Rol: ${employee.role}'),
                        if (employee.phone != null)
                          Text('Tel: ${employee.phone}'),
                        if (employee.storeId != null)
                          Text('Tienda ID: ${employee.storeId}'),
                        if (employee.warehouseId != null)
                          Text('Almacén ID: ${employee.warehouseId}'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EmployeeFormPage(employee: employee),
                              ),
                            );
                            break;
                          case 'delete':
                            _showDeleteDialog(context, employee);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmployeeFormPage(employee: employee),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is EmployeesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar empleados: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EmployeesBloc>().add(LoadEmployeesEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay datos disponibles'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmployeeFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Empleado'),
          content: Text(
            '¿Estás seguro de que quieres eliminar a ${employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<EmployeesBloc>().add(
                  DeleteEmployeeEvent(employee.id),
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.purple;
      case 'manager':
        return Colors.blue;
      case 'employee':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'manager':
        return Icons.manage_accounts;
      case 'employee':
        return Icons.person;
      default:
        return Icons.person_outline;
    }
  }
}
