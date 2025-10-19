abstract class EmployeesEvent {}

class LoadEmployeesEvent extends EmployeesEvent {}

class CreateEmployeeEvent extends EmployeesEvent {
  final String name;
  final String email;
  final String password;
  final String role;
  final int? storeId;
  final int? warehouseId;

  CreateEmployeeEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.storeId,
    this.warehouseId,
  });
}
