import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_state.dart';
import '../widgets/product_list_widget.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            return ProductListWidget(products: state.products);
          } else if (state is InventoryError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Select a store or warehouse'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/product_detail'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
