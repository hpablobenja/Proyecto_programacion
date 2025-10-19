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
  Future<void> updateEmployee(Employee employee) async {
    await localDataSource.updateEmployee(employee);
    if (await syncService.isOnline()) {
      await remoteDataSource.updateEmployee(employee);
      await syncService.syncPendingTransactions();
    } else {
      await syncService.enqueueTransaction(
        'update_employee',
        EmployeeModel.fromEntity(employee),
      );
    }
  }
}
