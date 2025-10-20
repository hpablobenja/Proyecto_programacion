import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/domain/entities/employee.dart';

class AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSource(this.supabaseClient);

  Future<Employee> login(String email, String password) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Authentication failed');
    return Employee(
      id: user.id.hashCode,
      name: user.email!.split('@')[0],
      email: user.email!,
      role: 'employee',
      phone: null,
      address: null,
      storeId: null,
      warehouseId: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
