import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transfers_bloc.dart';
import '../bloc/transfers_state.dart';

class TransfersPage extends StatelessWidget {
  const TransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfers')),
      body: BlocBuilder<TransfersBloc, TransfersState>(
        builder: (context, state) {
          if (state is TransfersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransfersLoaded) {
            return ListView.builder(
              itemCount: state.transfers.length,
              itemBuilder: (context, index) {
                final transfer = state.transfers[index];
                return ListTile(
                  title: Text('Transfer #${transfer.id}'),
                  subtitle: Text('From: ${transfer.fromLocationId}'),
                  trailing: Text('Qty: ${transfer.quantity}'),
                );
              },
            );
          } else if (state is TransfersError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No transfers found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add transfer
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
