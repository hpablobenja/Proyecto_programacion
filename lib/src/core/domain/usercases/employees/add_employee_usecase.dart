import '../../entities/employee.dart';
import '../../repositories/employees_repository.dart';

class AddEmployeeUseCase {
  final EmployeesRepository repository;

  AddEmployeeUseCase(this.repository);

  Future<Employee> call(Employee employee) async {
    return await repository.createEmployee(employee);
  }
}
