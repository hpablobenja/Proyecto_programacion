import '../../../../core/domain/entities/employee.dart';

abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;

  EmployeesLoaded(this.employees);
}

class EmployeeCreated extends EmployeesState {
  final Employee employee;

  EmployeeCreated(this.employee);
}

class EmployeeUpdated extends EmployeesState {
  final Employee employee;

  EmployeeUpdated(this.employee);
}

class EmployeeDeleted extends EmployeesState {
  final int employeeId;

  EmployeeDeleted(this.employeeId);
}

class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError(this.message);
}
