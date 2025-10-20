import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/purchases_bloc.dart';
import '../bloc/purchases_event.dart';
import '../bloc/purchases_state.dart';
import 'purchase_form_page.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  @override
  void initState() {
    super.initState();
    // Cargar compras al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchasesBloc>().add(LoadPurchasesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PurchasesBloc>().add(LoadPurchasesEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<PurchasesBloc, PurchasesState>(
        listener: (context, state) {
          if (state is PurchasesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PurchasesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Compra guardada exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PurchasesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PurchasesError) {
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
                      context.read<PurchasesBloc>().add(LoadPurchasesEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is PurchasesLoaded) {
            if (state.purchases.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay compras registradas',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Crea tu primera compra',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.purchases.length,
              itemBuilder: (context, index) {
                final purchase = state.purchases[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text(
                        '${purchase.quantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Compra #${purchase.id.toString().padLeft(6, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Producto ID: ${purchase.productId}'),
                        if (purchase.supplierName != null)
                          Text('Proveedor: ${purchase.supplierName}'),
                        if (purchase.totalPrice != null)
                          Text(
                            'Total: \$${purchase.totalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        Text(
                          'Fecha: ${_formatDate(purchase.createdAt)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implementar vista de detalle de compra
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No hay datos disponibles'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PurchaseFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
