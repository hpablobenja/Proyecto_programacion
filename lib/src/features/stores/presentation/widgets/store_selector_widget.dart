import 'package:flutter/material.dart';
import '../../../../core/domain/entities/store.dart';

class StoreSelectorWidget extends StatelessWidget {
  final List<Store> stores;
  final ValueChanged<Store?> onSelected;

  const StoreSelectorWidget({
    super.key,
    required this.stores,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Store>(
      hint: const Text('Select Store'),
      items: stores.map((store) {
        return DropdownMenuItem<Store>(value: store, child: Text(store.name));
      }).toList(),
      onChanged: onSelected,
    );
  }
}
