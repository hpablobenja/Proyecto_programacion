import 'package:flutter/material.dart';
import '../../../../core/domain/entities/warehouse.dart';

class WarehouseSelectorWidget extends StatelessWidget {
  final List<Warehouse> warehouses;
  final ValueChanged<Warehouse?> onSelected;

  const WarehouseSelectorWidget({
    super.key,
    required this.warehouses,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Warehouse>(
      hint: const Text('Select Warehouse'),
      items: warehouses.map((warehouse) {
        return DropdownMenuItem<Warehouse>(
          value: warehouse,
          child: Text(warehouse.name),
        );
      }).toList(),
      onChanged: onSelected,
    );
  }
}
