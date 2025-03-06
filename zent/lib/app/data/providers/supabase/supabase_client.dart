import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class SupabaseClientManager extends GetxService {
  static SupabaseClientManager? _instance;
  bool _initialized = false;

  SupabaseClientManager._();

  static Future<SupabaseClientManager> get instance async {
    if (_instance == null) {
      _instance = SupabaseClientManager._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  Future<void> _initialize() async {
    if (!_initialized) {
      await dotenv.load(fileName: ".env");

      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      );

      _initialized = true;
    }
  }

  SupabaseClient get client => Supabase.instance.client;
}
