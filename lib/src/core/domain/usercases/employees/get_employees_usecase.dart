import '../../entities/employee.dart';
import '../../repositories/employees_repository.dart';

class GetEmployeesUseCase {
  final EmployeesRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<List<Employee>> call() async {
    return await repository.getEmployees();
  }
}
