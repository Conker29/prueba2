import '../models/index.dart';
import 'supabase_service.dart';

class VaccinationService {
  final SupabaseService _supabaseService = SupabaseService();

  // Crear vacunación
  Future<void> createVaccination(VacunacionModel v) async {
    await _supabaseService.vaccinationsTable.insert(_toSupabaseMap(v));
  }

  // Actualizar vacunación
  Future<void> updateVaccination(VacunacionModel v) async {
    await _supabaseService.vaccinationsTable
        .update(_toSupabaseMap(v))
        .eq('id', v.id);
  }

  // Obtener vacunación por ID
  Future<VacunacionModel?> getVaccinationById(String id) async {
    try {
      final response = await _supabaseService.vaccinationsTable
          .select()
          .eq('id', id)
          .single();
      return _fromSupabaseMap(response);
    } catch (e) {
      return null;
    }
  }

  // Obtener vacunaciones por vacunador
  Future<List<VacunacionModel>> getVaccinationsByVaccinator(
      String vaccinatorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('vacunador_uid', vaccinatorId);
    return (response as List).map(_fromSupabaseMap).toList();
  }

  // Obtener vacunaciones por sector
  Future<List<VacunacionModel>> getVaccinationsBySector(
      String sectorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('sector', sectorId);
    return (response as List).map(_fromSupabaseMap).toList();
  }

  // Obtener vacunaciones por coordinador de brigada
  Future<List<VacunacionModel>> getVaccinationsByBrigadeCoordinator(
      String brigadeCoordinatorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('brigade_coordinator_id', brigadeCoordinatorId);
    return (response as List).map(_fromSupabaseMap).toList();
  }

  // Obtener todas las vacunaciones
  Future<List<VacunacionModel>> getAllVaccinations() async {
    final response = await _supabaseService.vaccinationsTable.select();
    return (response as List).map(_fromSupabaseMap).toList();
  }

  // Obtener vacunaciones pendientes de sincronización
  Future<List<VacunacionModel>> getPendingSyncVaccinations() async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('sincronizado', false);
    return (response as List).map(_fromSupabaseMap).toList();
  }

  // Estadísticas por sector
  Future<Map<String, int>> getStatisticsBySector(String sectorId) async {
    final list = await getVaccinationsBySector(sectorId);
    return _buildStats(list);
  }

  // Estadísticas por vacunador
  Future<Map<String, int>> getStatisticsByVaccinator(
      String vaccinatorId) async {
    final list = await getVaccinationsByVaccinator(vaccinatorId);
    return _buildStats(list);
  }

  // Estadísticas generales
  Future<Map<String, int>> getGeneralStatistics() async {
    final list = await getAllVaccinations();
    return _buildStats(list);
  }

  // Eliminar vacunación
  Future<void> deleteVaccination(String id) async {
    await _supabaseService.vaccinationsTable.delete().eq('id', id);
  }

  // ── Helpers ──

  Map<String, int> _buildStats(List<VacunacionModel> list) => {
        'total': list.length,
        'dogs': list.where((v) => v.tipoMascota == 'perro').length,
        'cats': list.where((v) => v.tipoMascota == 'gato').length,
      };

  Map<String, dynamic> _toSupabaseMap(VacunacionModel v) => {
        'id': v.id,
        'propietario_nombre': v.propietarioNombre,
        'propietario_cedula': v.propietarioCedula,
        'telefono': v.telefono,
        'tipo_mascota': v.tipoMascota,
        'nombre_mascota': v.nombreMascota,
        'edad': v.edad,
        'sexo': v.sexo,
        'vacuna_aplicada': v.vacunaAplicada,
        'observaciones': v.observaciones,
        'foto_url': v.fotoUrl,
        'latitud': v.latitud,
        'longitud': v.longitud,
        'fecha_hora': v.fechaHora.toIso8601String(),
        'sector': v.sector,
        'vacunador_uid': v.vacunadorUid,
        'vacunador_nombre': v.vacunadorNombre,
        'sincronizado': v.sincronizado,
      };

  VacunacionModel _fromSupabaseMap(Map<String, dynamic> map) => VacunacionModel(
        id: map['id'] ?? '',
        propietarioNombre: map['propietario_nombre'] ?? '',
        propietarioCedula: map['propietario_cedula'] ?? '',
        telefono: map['telefono'] ?? '',
        tipoMascota: map['tipo_mascota'] ?? '',
        nombreMascota: map['nombre_mascota'] ?? '',
        edad: map['edad'] ?? '',
        sexo: map['sexo'] ?? '',
        vacunaAplicada: map['vacuna_aplicada'] ?? '',
        observaciones: map['observaciones'] ?? '',
        fotoUrl: map['foto_url'] ?? '',
        latitud: (map['latitud'] ?? 0).toDouble(),
        longitud: (map['longitud'] ?? 0).toDouble(),
        fechaHora: DateTime.parse(
            map['fecha_hora'] ?? DateTime.now().toIso8601String()),
        sector: map['sector'] ?? '',
        vacunadorUid: map['vacunador_uid'] ?? '',
        vacunadorNombre: map['vacunador_nombre'] ?? '',
        sincronizado: map['sincronizado'] ?? false,
      );
}
