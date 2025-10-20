import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transfers_bloc.dart';
import '../bloc/transfers_event.dart';
import '../bloc/transfers_state.dart';
import 'transfer_form_page.dart';

class TransfersPage extends StatefulWidget {
  const TransfersPage({super.key});

  @override
  State<TransfersPage> createState() => _TransfersPageState();
}

class _TransfersPageState extends State<TransfersPage> {
  @override
  void initState() {
    super.initState();
    // Cargar transferencias al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransfersBloc>().add(LoadTransfersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TransfersBloc>().add(LoadTransfersEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<TransfersBloc, TransfersState>(
        listener: (context, state) {
          if (state is TransfersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TransfersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransfersError) {
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
                      context.read<TransfersBloc>().add(LoadTransfersEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is TransfersLoaded) {
            if (state.transfers.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.swap_horiz, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay transferencias registradas',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Crea tu primera transferencia',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.transfers.length,
              itemBuilder: (context, index) {
                final transfer = state.transfers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getTransferColor(
                        transfer.fromLocationType,
                      ),
                      child: Icon(
                        _getTransferIcon(transfer.fromLocationType),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Transferencia #${transfer.id.toString().padLeft(6, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Producto ID: ${transfer.productId}'),
                        Text('Cantidad: ${transfer.quantity}'),
                        Text(
                          'De: ${transfer.fromLocationType} #${transfer.fromLocationId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'A: ${transfer.toLocationType} #${transfer.toLocationId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                        if (transfer.notes != null)
                          Text(
                            'Notas: ${transfer.notes}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          'Fecha: ${_formatDate(transfer.createdAt)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implementar vista de detalle de transferencia
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
          MaterialPageRoute(builder: (context) => const TransferFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getTransferColor(String locationType) {
    return locationType == 'store' ? Colors.blue : Colors.orange;
  }

  IconData _getTransferIcon(String locationType) {
    return locationType == 'store' ? Icons.store : Icons.warehouse;
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
