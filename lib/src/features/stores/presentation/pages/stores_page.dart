import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stores_bloc.dart';
import '../bloc/stores_event.dart';
import '../bloc/stores_state.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  @override
  void initState() {
    super.initState();
    context.read<StoresBloc>().add(LoadStoresEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StoresBloc>().add(LoadStoresEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<StoresBloc, StoresState>(
        builder: (context, state) {
          if (state is StoresLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StoresLoaded) {
            if (state.stores.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay tiendas registradas',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              itemCount: state.stores.length,
              itemBuilder: (context, index) {
                final store = state.stores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.store),
                    ),
                    title: Text(
                      store.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(store.address),
                        if (store.phone != null)
                          Text('Tel: ${store.phone}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/store_detail',
                      arguments: store,
                    ),
                  ),
                );
              },
            );
          } else if (state is StoresError) {
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
                      context.read<StoresBloc>().add(LoadStoresEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay tiendas disponibles'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/store_detail'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tienda'),
      ),
    );
  }
}
