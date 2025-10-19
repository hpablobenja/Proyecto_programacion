import 'package:flutter/material.dart';
import '../../../../core/domain/entities/client.dart';

class ClientSelectorWidget extends StatelessWidget {
  final List<Client> clients;
  final ValueChanged<Client?> onSelected;

  const ClientSelectorWidget({
    super.key,
    required this.clients,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Client>(
      hint: const Text('Select Client'),
      items: clients.map((client) {
        return DropdownMenuItem<Client>(
          value: client,
          child: Text(client.name),
        );
      }).toList(),
      onChanged: onSelected,
    );
  }
}
