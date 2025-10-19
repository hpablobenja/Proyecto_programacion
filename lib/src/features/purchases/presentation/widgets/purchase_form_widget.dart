import 'package:flutter/material.dart';

class PurchaseFormWidget extends StatelessWidget {
  const PurchaseFormWidget({super.key});

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
            // Lógica para crear compra
            Navigator.pop(context);
          },
          child: const Text('Create Purchase'),
        ),
      ],
    );
  }
}
