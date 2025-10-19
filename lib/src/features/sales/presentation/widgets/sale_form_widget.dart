import 'package:flutter/material.dart';

class SaleFormWidget extends StatelessWidget {
  const SaleFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: productIdController,
          decoration: const InputDecoration(labelText: 'Product ID'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: quantityController,
          decoration: const InputDecoration(labelText: 'Quantity'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Lógica para crear venta
            Navigator.pop(context);
          },
          child: const Text('Create Sale'),
        ),
      ],
    );
  }
}
