import '../../../../core/domain/entities/employee.dart';

abstract class EmployeesEvent {}

class LoadEmployeesEvent extends EmployeesEvent {}

class CreateEmployeeEvent extends EmployeesEvent {
  final Employee employee;

  CreateEmployeeEvent(this.employee);
}

class UpdateEmployeeEvent extends EmployeesEvent {
  final Employee employee;

  UpdateEmployeeEvent(this.employee);
}

class DeleteEmployeeEvent extends EmployeesEvent {
  final int employeeId;

  DeleteEmployeeEvent(this.employeeId);
}
