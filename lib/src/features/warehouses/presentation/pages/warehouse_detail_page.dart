import 'package:flutter/material.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../widgets/warehouse_form_widget.dart';

class WarehouseDetailPage extends StatelessWidget {
  final Warehouse? warehouse;

  const WarehouseDetailPage({super.key, this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(warehouse == null ? 'Nuevo Almacén' : 'Editar Almacén'),
      ),
      body: WarehouseFormWidget(warehouse: warehouse),
    );
  }
}
