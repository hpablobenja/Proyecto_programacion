import '../../entities/employee.dart';
import '../../repositories/employees_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeesRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<void> call(Employee employee) async {
    await repository.updateEmployee(employee);
  }
}
