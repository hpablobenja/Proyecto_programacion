import '../../entities/employee.dart';
import '../../repositories/employees_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeesRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<Employee> call(Employee employee) async {
    return await repository.updateEmployee(employee);
  }
}
