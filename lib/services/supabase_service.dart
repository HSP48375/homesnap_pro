import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/env.dart';

class SupabaseService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    _initialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
  static SupabaseClient get clientSync => Supabase.instance.client;
}
