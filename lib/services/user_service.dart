import '../models/index.dart';
import 'supabase_service.dart';

class UserService {
  final SupabaseService _supabaseService = SupabaseService();

  // Crear usuario
  Future<void> createUser(UsuarioModel usuario) async {
    await _supabaseService.usersTable.insert(_toSupabaseMap(usuario));
  }

  // Obtener usuario por ID
  Future<UsuarioModel?> getUserById(String id) async {
    try {
      final response = await _supabaseService.usersTable
          .select()
          .eq('id', id)
          .single();
      return _fromSupabaseMap(response);
    } catch (e) {
      return null;
    }
  }

  // Obtener usuario por email
  Future<UsuarioModel?> getUserByEmail(String email) async {
    try {
      final response = await _supabaseService.usersTable
          .select()
          .eq('email', email)
          .single();
      return _fromSupabaseMap(response);
    } catch (e) {
      return null;
    }
  }

  // Actualizar usuario
  Future<void> updateUser(UsuarioModel usuario) async {
    await _supabaseService.usersTable
        .update(_toSupabaseMap(usuario))
        .eq('id', usuario.uid);
  }

  // Obtener todos los coordinadores de brigada
  Future<List<UsuarioModel>> getBrigadeCoordinators() async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'coordinador_brigada')
        .eq('is_active', true);
    return (response as List).map((e) => _fromSupabaseMap(e)).toList();
  }

  // Obtener coordinadores de brigada por sector
  Future<List<UsuarioModel>> getBrigadeCoordinatorsBySector(
      String sectorId) async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'coordinador_brigada')
        .eq('sector_id', sectorId)
        .eq('is_active', true);
    return (response as List).map((e) => _fromSupabaseMap(e)).toList();
  }

  // Obtener vacunadores por coordinador de brigada
  Future<List<UsuarioModel>> getVaccinatorsByBrigadeCoordinator(
      String brigadeCoordinatorId) async {
    final brigadeResponse = await _supabaseService.brigadesTable
        .select('sector_id')
        .eq('brigade_coordinator_id', brigadeCoordinatorId);

    final sectorIds = (brigadeResponse as List)
        .map<String>((b) => b['sector_id'] as String)
        .toList();

    if (sectorIds.isEmpty) return [];

    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'vacunador')
        .inFilter('sector_id', sectorIds)
        .eq('is_active', true);

    return (response as List).map((e) => _fromSupabaseMap(e)).toList();
  }

  // Obtener vacunadores por sector
  Future<List<UsuarioModel>> getVaccinatorsBySector(String sectorId) async {
    final response = await _supabaseService.usersTable
        .select()
        .eq('role', 'vacunador')
        .eq('sector_id', sectorId)
        .eq('is_active', true);
    return (response as List).map((e) => _fromSupabaseMap(e)).toList();
  }

  // Marcar contraseña como cambiada
  Future<void> markPasswordAsChanged(String userId) async {
    await _supabaseService.usersTable
        .update({'debe_cambiar_password': false}).eq('id', userId);
  }

  // Desactivar usuario
  Future<void> deactivateUser(String userId) async {
    await _supabaseService.usersTable
        .update({'is_active': false}).eq('id', userId);
  }

  // ── Mapeo entre UsuarioModel (Firebase/local) y esquema Supabase ──

  Map<String, dynamic> _toSupabaseMap(UsuarioModel u) => {
        'id': u.uid,
        'cedula': u.cedula,
        'nombres': u.nombres,
        'apellidos': u.apellidos,
        'telefono': u.telefono,
        'email': u.correo,
        'role': u.rol,
        'sectores_asignados': u.sectoresAsignados,
        'debe_cambiar_password': u.debeCambiarPassword,
        'creado_por': u.creadoPor,
        'is_active': true,
      };

  UsuarioModel _fromSupabaseMap(Map<String, dynamic> map) => UsuarioModel(
        uid: map['id'] ?? '',
        cedula: map['cedula'] ?? '',
        nombres: map['nombres'] ?? '',
        apellidos: map['apellidos'] ?? '',
        telefono: map['telefono'] ?? '',
        correo: map['email'] ?? '',
        rol: map['role'] ?? '',
        sectoresAsignados:
            List<String>.from(map['sectores_asignados'] ?? []),
        debeCambiarPassword: map['debe_cambiar_password'] ?? true,
        creadoPor: map['creado_por'],
      );
}
