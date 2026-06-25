import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  SupabaseClient get client => _client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANON_KEY,
    );
    _client = Supabase.instance.client;
  }

  // Tablas
  get usersTable => _client.from('users');
  get sectorsTable => _client.from('sectors');
  get brigadesTable => _client.from('brigades');
  get vaccinationsTable => _client.from('vaccinations');

  // Autenticación
  get auth => _client.auth;

  // Storage
  get storage => _client.storage;

  bool get isAuthenticated => _client.auth.currentSession != null;
  User? get currentUser => _client.auth.currentUser;
}
