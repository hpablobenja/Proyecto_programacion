import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/models/employee_model.dart';
import '../../../../core/domain/entities/employee.dart';

class EmployeesRemoteDataSource {
  final SupabaseClient supabaseClient;

  EmployeesRemoteDataSource(this.supabaseClient);

  Future<List<Employee>> getEmployees() async {
    final response = await supabaseClient.from('employees').select();
    return (response as List)
        .map((json) => EmployeeModel.fromJson(json).toEntity())
        .toList();
  }

  Future<Employee> createEmployee(Employee employee) async {
    final response = await supabaseClient
        .from('employees')
        .insert(EmployeeModel.fromEntity(employee).toJson())
        .select()
        .single();
    return EmployeeModel.fromJson(response).toEntity();
  }

  Future<Employee> updateEmployee(Employee employee) async {
    final response = await supabaseClient
        .from('employees')
        .update(EmployeeModel.fromEntity(employee).toJson())
        .eq('id', employee.id)
        .select()
        .single();
    return EmployeeModel.fromJson(response).toEntity();
  }

  Future<void> deleteEmployee(int employeeId) async {
    await supabaseClient.from('employees').delete().eq('id', employeeId);
  }
}
