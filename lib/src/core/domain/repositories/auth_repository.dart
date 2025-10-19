import '../../domain/entities/employee.dart';

abstract class AuthRepository {
  Future<Employee> login(String email, String password);
  Future<void> logout();
}
