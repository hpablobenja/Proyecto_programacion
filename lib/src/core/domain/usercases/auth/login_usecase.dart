import '../../../../core/domain/entities/employee.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Employee> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
