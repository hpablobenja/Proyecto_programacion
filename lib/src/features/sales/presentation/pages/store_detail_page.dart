import 'package:flutter/material.dart';
import '../widgets/sale_form_widget.dart';

class SaleDetailPage extends StatelessWidget {
  const SaleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Sale')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SaleFormWidget(),
      ),
    );
  }
}
