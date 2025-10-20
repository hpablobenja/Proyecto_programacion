import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/domain/repositories/auth_repository.dart';
import '../../../../core/domain/entities/employee.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Employee> login(String email, String password) async {
    try {
      print(' Iniciando login remoto...');
      final employee = await remoteDataSource.login(email, password);
      print(' Login remoto exitoso: ${employee.email}');
      try {
        await localDataSource.cacheUser(employee, rawPassword: password);
      } catch (_) {}
      return employee;
    } catch (e) {
      print(' Login remoto falló: $e. Intentando login offline...');
      final offline = await localDataSource.loginOffline(email, password);
      if (offline != null) {
        print(' Login offline exitoso');
        return offline;
      }
      throw Exception('Login failed (offline not available)');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
