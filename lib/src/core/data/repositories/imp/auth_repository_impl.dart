import '../../../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/entities/employee.dart';

// Esta es una implementación concreta del repositorio de autenticación.
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
      final employee = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(employee);
      return employee;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
