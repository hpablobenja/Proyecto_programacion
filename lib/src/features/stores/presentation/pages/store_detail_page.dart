import 'package:flutter/material.dart';
import '../../../../core/domain/entities/store.dart';
import '../widgets/store_form_widget.dart';

class StoreDetailPage extends StatelessWidget {
  final Store? store;

  const StoreDetailPage({super.key, this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(store == null ? 'Nueva Tienda' : 'Editar Tienda'),
      ),
      body: StoreFormWidget(store: store),
    );
  }
}
