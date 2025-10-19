import '../entities/employee.dart';

abstract class EmployeesRepository {
  Future<List<Employee>> getEmployees();
  Future<void> updateEmployee(Employee employee);
}
