import '../../../../core/domain/entities/employee.dart';

abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;

  EmployeesLoaded(this.employees);
}

class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError(this.message);
}
