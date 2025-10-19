import 'package:flutter/material.dart';
import '../../../../core/domain/entities/employee.dart';

class EmployeeFormWidget extends StatelessWidget {
  final Employee? employee;

  const EmployeeFormWidget({super.key, this.employee});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: employee?.email);
    final roleController = TextEditingController(text: employee?.role);

    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: roleController,
          decoration: const InputDecoration(labelText: 'Role'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Lógica para guardar empleado
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
