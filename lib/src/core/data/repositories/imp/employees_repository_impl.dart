import '../../../services/sync_service.dart';
import '../../models/employee_model.dart';
import '../../../domain/entities/employee.dart';
import '../../../domain/repositories/employees_repository.dart';
import '../../../../features/employees/data/datasources/employees_local_datasource.dart';
import '../../../../features/employees/data/datasources/employees_remote_datasource.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesLocalDataSource localDataSource;
  final EmployeesRemoteDataSource remoteDataSource;
  final SyncService syncService;

  EmployeesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.syncService,
  });

  @override
  Future<List<Employee>> getEmployees() async {
    if (await syncService.isOnline()) {
      final remoteEmployees = await remoteDataSource.getEmployees();
      await localDataSource.saveEmployees(remoteEmployees);
      return remoteEmployees;
    }
    return await localDataSource.getEmployees();
  }

  @override
  Future<Employee> createEmployee(Employee employee) async {
    if (await syncService.isOnline()) {
      final createdEmployee = await remoteDataSource.createEmployee(employee);
      await localDataSource.saveEmployees([createdEmployee]);
      return createdEmployee;
    } else {
      final createdEmployee = await localDataSource.createEmployee(employee);
      await syncService.enqueueTransaction(
        'create_employee',
        EmployeeModel.fromEntity(createdEmployee),
      );
      return createdEmployee;
    }
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    if (await syncService.isOnline()) {
      final updatedEmployee = await remoteDataSource.updateEmployee(employee);
      await localDataSource.updateEmployee(updatedEmployee);
      return updatedEmployee;
    } else {
      await localDataSource.updateEmployee(employee);
      await syncService.enqueueTransaction(
        'update_employee',
        EmployeeModel.fromEntity(employee),
      );
      return employee;
    }
  }

  @override
  Future<void> deleteEmployee(int employeeId) async {
    if (await syncService.isOnline()) {
      await remoteDataSource.deleteEmployee(employeeId);
      await localDataSource.deleteEmployee(employeeId);
    } else {
      await localDataSource.deleteEmployee(employeeId);
      await syncService.enqueueTransaction('delete_employee', {
        'id': employeeId,
      });
    }
  }
}
