import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/index.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _supabaseService.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabaseService.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabaseService.auth.signOut();
  }

  Future<void> changePassword({
    required String newPassword,
  }) async {
    await _supabaseService.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> resetPasswordForEmail(String email) async {
    await _supabaseService.auth.resetPasswordForEmail(email);
  }

  bool get isAuthenticated => _supabaseService.isAuthenticated;
  User? get currentUser => _supabaseService.currentUser;
}
