import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sales_bloc.dart';
import '../bloc/sales_event.dart';
import '../bloc/sales_state.dart';
import 'sale_detail_page.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load sales when the page is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!(context.read<SalesBloc>().state is SalesLoading)) {
        final now = DateTime.now();
        final startDate = DateTime(now.year, now.month, now.day);
        context.read<SalesBloc>().add(
          LoadSalesEvent(
            null, // storeId
            startDate,
            now,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final now = DateTime.now();
              final startDate = DateTime(now.year, now.month, now.day);
              context.read<SalesBloc>().add(
                LoadSalesEvent(
                  null, // storeId
                  startDate,
                  now,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<SalesBloc, SalesState>(
        listener: (context, state) {
          if (state is SalesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Venta guardada exitosamente')),
            );
            // Reload sales after a successful sale
            final now = DateTime.now();
            final startDate = DateTime(now.year, now.month, now.day);
            context.read<SalesBloc>().add(
              LoadSalesEvent(
                null, // storeId
                startDate,
                now,
              ),
            );
          } else if (state is SalesError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SalesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final now = DateTime.now();
                      final startDate = DateTime(now.year, now.month, now.day);
                      context.read<SalesBloc>().add(
                        LoadSalesEvent(
                          null,
                          startDate,
                          now,
                        ),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is SalesLoaded) {
            final sales = state.sales;

            if (sales.isEmpty) {
              return const Center(child: Text('No hay ventas registradas'));
            }

            return ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(
                      'Venta #${sale.id.toString().substring(sale.id.toString().length - 4)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Producto ID: ${sale.productId}'),
                        Text('Cantidad: ${sale.quantity}'),
                        Text(
                          'Fecha: ${_formatDate(sale.createdAt)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implementar vista de detalle de venta
                    },
                  ),
                );
              },
            );
          } else if (state is SalesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final now = DateTime.now();
                      final startDate = DateTime(now.year, now.month, now.day);
                      context.read<SalesBloc>().add(
                        LoadSalesEvent(
                          null, // storeId
                          startDate,
                          now,
                        ),
                      );
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
          MaterialPageRoute(builder: (context) => const SaleDetailPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
