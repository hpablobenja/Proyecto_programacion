import 'package:flutter/material.dart';
import '../widgets/purchase_form_widget.dart';

class PurchaseDetailPage extends StatelessWidget {
  const PurchaseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Purchase')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PurchaseFormWidget(),
      ),
    );
  }
}
