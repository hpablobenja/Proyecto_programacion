import 'package:flutter/material.dart';
import '../widgets/employee_form_widget.dart';
import '../../../../core/domain/entities/employee.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee? employee;

  const EmployeeDetailPage({super.key, this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EmployeeFormWidget(employee: employee),
      ),
    );
  }
}
