import 'package:flutter/material.dart';

class TransferFormWidget extends StatelessWidget {
  const TransferFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();
    final fromLocationController = TextEditingController();
    final toLocationController = TextEditingController();

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
        TextField(
          controller: fromLocationController,
          decoration: const InputDecoration(labelText: 'From Location ID'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: toLocationController,
          decoration: const InputDecoration(labelText: 'To Location ID'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Lógica para crear transferencia
            Navigator.pop(context);
          },
          child: const Text('Create Transfer'),
        ),
      ],
    );
  }
}
