import '../../repositories/employees_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeesRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<void> call(int employeeId) async {
    return await repository.deleteEmployee(employeeId);
  }
}
