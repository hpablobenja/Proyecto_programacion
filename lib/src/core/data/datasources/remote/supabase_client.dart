import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static final SupabaseManager _instance = SupabaseManager._internal();

  factory SupabaseManager() => _instance;

  SupabaseManager._internal();

  final SupabaseClient client = Supabase.instance.client;
}
