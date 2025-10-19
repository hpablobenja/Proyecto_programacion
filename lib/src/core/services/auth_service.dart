import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabaseClient;

  AuthService(this.supabaseClient);

  Future<void> signIn(String email, String password) async {
    await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }
}
