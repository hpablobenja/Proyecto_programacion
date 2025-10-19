import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/warehouses_bloc.dart';
import '../bloc/warehouses_event.dart';
import '../bloc/warehouses_state.dart';
import 'warehouse_detail_page.dart';

class WarehousesPage extends StatefulWidget {
  const WarehousesPage({super.key});

  @override
  State<WarehousesPage> createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  @override
  void initState() {
    super.initState();
    context.read<WarehousesBloc>().add(LoadWarehousesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almacenes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WarehousesBloc>().add(LoadWarehousesEvent());
            },
            tooltip: 'Actualizar lista',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'add':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WarehouseDetailPage(),
                    ),
                  );
                  break;
                case 'export':
                  // TODO: Implementar exportación de almacenes
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exportando lista de almacenes...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  break;
                case 'settings':
                  // TODO: Implementar configuración de almacenes
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ajustes de almacenes'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'add',
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Agregar Almacén'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.file_download, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Exportar a Excel'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Configuración'),
                    ],
                  ),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: BlocBuilder<WarehousesBloc, WarehousesState>(
        builder: (context, state) {
          if (state is WarehousesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WarehousesLoaded) {
            if (state.warehouses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warehouse, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay almacenes registrados',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Primer Almacén'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WarehouseDetailPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              itemCount: state.warehouses.length,
              itemBuilder: (context, index) {
                final warehouse = state.warehouses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.warehouse),
                    ),
                    title: Text(
                      warehouse.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(warehouse.address),
                        if (warehouse.phone != null)
                          Text('Tel: ${warehouse.phone}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/warehouse_detail',
                      arguments: warehouse,
                    ),
                  ),
                );
              },
            );
          } else if (state is WarehousesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WarehousesBloc>().add(LoadWarehousesEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay almacenes disponibles'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/warehouse_detail'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Almacén'),
      ),
    );
  }
}
