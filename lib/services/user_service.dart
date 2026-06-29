import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/index.dart';
import 'supabase_service.dart';

class UserService {
  final SupabaseService _supabaseService = SupabaseService();

  // Crear usuario
  Future<void> createUser(User user) async {
    await _supabaseService.usersTable.insert(user.toMap());
  }

  // Obtener usuario por ID
  Future<User?> getUserById(String id) async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('id', id)
        .single();
    return User.fromMap(response);
  }

  // Obtener usuario por email
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _supabaseService.usersTable
          .select()
          .eq('email', email)
          .single();
      return User.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  // Actualizar usuario
  Future<void> updateUser(User user) async {
    await _supabaseService.usersTable
        .update(user.toMap())
        .eq('id', user.id);
  }

  // Obtener todos los coordinadores de brigada
  Future<List<User>> getBrigadeCoordinators() async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'brigade_coordinator')
        .eq('is_active', true);
    return (response as List).map((e) => User.fromMap(e)).toList();
  }

  // Obtener coordinadores de brigada por sector
  Future<List<User>> getBrigadeCoordinatorsBySector(String sectorId) async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'brigade_coordinator')
        .eq('sector_id', sectorId)
        .eq('is_active', true);
    return (response as List).map((e) => User.fromMap(e)).toList();
  }

  // Obtener vacunadores por coordinador de brigada
  Future<List<User>> getVaccinatorsByBrigadeCoordinator(
      String brigadeCoordinatorId) async {
    // Primero obtener los coordinadores de brigada con sus sectores asignados
    final brigadeResponse = await _supabaseService.brigadesTable
        .select('sector_id')
        .eq('brigade_coordinator_id', brigadeCoordinatorId);

    List<String> sectorIds = [];
    for (var brigade in brigadeResponse as List) {
      sectorIds.add(brigade['sector_id']);
    }

    if (sectorIds.isEmpty) {
      return [];
    }

    // Luego obtener los vacunadores en esos sectores
    final response = await _supabaseService.usersTable.select();
    final users = (response as List).map((e) => User.fromMap(e)).toList();

    return users
        .where((user) =>
            user.role == UserRole.vaccinator &&
            user.sectorId != null &&
            sectorIds.contains(user.sectorId))
        .toList();
  }

  // Obtener vacunadores por sector
  Future<List<User>> getVaccinatorsBySector(String sectorId) async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'vaccinator')
        .eq('sector_id', sectorId)
        .eq('is_active', true);
    return (response as List).map((e) => User.fromMap(e)).toList();
  }

  // Cambiar estado de contraseña
  Future<void> markPasswordAsChanged(String userId) async {
    await _supabaseService.usersTable
        .update({'password_changed': true})
        .eq('id', userId);
  }

  // Desactivar usuario
  Future<void> deactivateUser(String userId) async {
    await _supabaseService.usersTable
        .update({'is_active': false})
        .eq('id', userId);
  }
}

extension on User {
  toMap() {}
}
