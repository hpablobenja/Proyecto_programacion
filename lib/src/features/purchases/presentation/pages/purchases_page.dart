import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/purchases_bloc.dart';
import '../bloc/purchases_state.dart';

class PurchasesPage extends StatelessWidget {
  const PurchasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),
      body: BlocBuilder<PurchasesBloc, PurchasesState>(
        builder: (context, state) {
          if (state is PurchasesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PurchasesLoaded) {
            return ListView.builder(
              itemCount: state.purchases.length,
              itemBuilder: (context, index) {
                final purchase = state.purchases[index];
                return ListTile(
                  title: Text('Purchase #${purchase.id}'),
                  subtitle: Text(
                    'Product: ${purchase.productId}, Qty: ${purchase.quantity}',
                  ),
                );
              },
            );
          } else if (state is PurchasesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No purchases available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/purchase_detail'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
