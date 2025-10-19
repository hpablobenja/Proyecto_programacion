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

  Future<void> updateEmployee(Employee employee) async {
    await supabaseClient
        .from('employees')
        .update(EmployeeModel.fromEntity(employee).toJson())
        .eq('id', employee.id);
  }
}
