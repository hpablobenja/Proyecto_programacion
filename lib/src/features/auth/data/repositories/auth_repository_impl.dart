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

      // TEMPORALMENTE DESHABILITADO - Intentar cachear el usuario
      // Descomenta esto cuando la base de datos funcione correctamente
      /*
      try {
        print(' Intentando cachear usuario...');
        await localDataSource.cacheUser(employee);
        print(' Usuario cacheado exitosamente');
      } catch (cacheError) {
        print(' Warning: Failed to cache user: $cacheError');
        // Continuar aunque falle el caché
      }
      */
      print('Caché local deshabilitado temporalmente');

      print('Login completado');
      return employee;
    } catch (e) {
      print(' Error en login: $e');
      throw Exception('Login failed: $e');
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
