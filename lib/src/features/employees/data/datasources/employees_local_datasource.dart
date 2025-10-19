import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/employee.dart' as domain;

class EmployeesLocalDataSource {
  final AppDatabase database;

  EmployeesLocalDataSource(this.database);

  Future<List<domain.Employee>> getEmployees() async {
    // Implementar almacenamiento local si necesario
    return [];
  }

  Future<void> saveEmployees(List<domain.Employee> employees) async {
    // Implementar almacenamiento local si necesario
  }

  Future<void> updateEmployee(domain.Employee employee) async {
    // Implementar actualización local si necesario
  }
}
