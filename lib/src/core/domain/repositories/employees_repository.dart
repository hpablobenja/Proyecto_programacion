import '../entities/employee.dart';

abstract class EmployeesRepository {
  Future<List<Employee>> getEmployees();
  Future<Employee> createEmployee(Employee employee);
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deleteEmployee(int employeeId);
}
