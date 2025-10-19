import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employees_bloc.dart';
import '../bloc/employees_state.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeesLoaded) {
            return ListView.builder(
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                final employee = state.employees[index];
                return ListTile(
                  title: Text(employee.email),
                  subtitle: Text('Role: ${employee.role}'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/employee_detail',
                    arguments: employee,
                  ),
                );
              },
            );
          } else if (state is EmployeesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No employees available'));
        },
      ),
    );
  }
}
