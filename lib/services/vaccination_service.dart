import '../models/index.dart';
import 'supabase_service.dart';

class VaccinationService {
  final SupabaseService _supabaseService = SupabaseService();

  // Crear vacunación
  Future<void> createVaccination(Vaccination vaccination) async {
    await _supabaseService.vaccinationsTable.insert(vaccination.toMap());
  }

  // Actualizar vacunación
  Future<void> updateVaccination(Vaccination vaccination) async {
    await _supabaseService.vaccinationsTable
        .update(vaccination.toMap())
        .eq('id', vaccination.id);
  }

  // Obtener vacunación por ID
  Future<Vaccination?> getVaccinationById(String id) async {
    try {
      final response = await _supabaseService.vaccinationsTable
          .select()
          .eq('id', id)
          .single();
      return Vaccination.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  // Obtener vacunaciones por vacunador
  Future<List<Vaccination>> getVaccinationsByVaccinator(
      String vaccinatorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('vaccinator_id', vaccinatorId);
    return (response as List).map((e) => Vaccination.fromMap(e)).toList();
  }

  // Obtener vacunaciones por sector
  Future<List<Vaccination>> getVaccinationsBySector(String sectorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('sector_id', sectorId);
    return (response as List).map((e) => Vaccination.fromMap(e)).toList();
  }

  // Obtener vacunaciones por coordinador de brigada
  Future<List<Vaccination>> getVaccinationsByBrigadeCoordinator(
      String brigadeCoordinatorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('brigade_coordinator_id', brigadeCoordinatorId);
    return (response as List).map((e) => Vaccination.fromMap(e)).toList();
  }

  // Obtener todas las vacunaciones
  Future<List<Vaccination>> getAllVaccinations() async {
    final response = await _supabaseService.vaccinationsTable.select();
    return (response as List).map((e) => Vaccination.fromMap(e)).toList();
  }

  // Obtener vacunaciones pendientes de sincronización
  Future<List<Vaccination>> getPendingSyncVaccinations() async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('sync_status', 'pending');
    return (response as List).map((e) => Vaccination.fromMap(e)).toList();
  }

  // Obtener estadísticas por sector
  Future<Map<String, int>> getStatisticsBySector(String sectorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('sector_id', sectorId);

    final vaccinations =
        (response as List).map((e) => Vaccination.fromMap(e)).toList();

    int totalVaccinations = vaccinations.length;
    int dogsVaccinated =
        vaccinations.where((v) => v.petType == PetType.dog).length;
    int catsVaccinated =
        vaccinations.where((v) => v.petType == PetType.cat).length;

    return {
      'total': totalVaccinations,
      'dogs': dogsVaccinated,
      'cats': catsVaccinated,
    };
  }

  // Obtener estadísticas por vacunador
  Future<Map<String, int>> getStatisticsByVaccinator(
      String vaccinatorId) async {
    final response = await _supabaseService.vaccinationsTable
        .select()
        .eq('vaccinator_id', vaccinatorId);

    final vaccinations =
        (response as List).map((e) => Vaccination.fromMap(e)).toList();

    int totalVaccinations = vaccinations.length;
    int dogsVaccinated =
        vaccinations.where((v) => v.petType == PetType.dog).length;
    int catsVaccinated =
        vaccinations.where((v) => v.petType == PetType.cat).length;

    return {
      'total': totalVaccinations,
      'dogs': dogsVaccinated,
      'cats': catsVaccinated,
    };
  }

  // Obtener estadísticas generales
  Future<Map<String, int>> getGeneralStatistics() async {
    final response = await _supabaseService.vaccinationsTable.select();

    final vaccinations =
        (response as List).map((e) => Vaccination.fromMap(e)).toList();

    int totalVaccinations = vaccinations.length;
    int dogsVaccinated =
        vaccinations.where((v) => v.petType == PetType.dog).length;
    int catsVaccinated =
        vaccinations.where((v) => v.petType == PetType.cat).length;

    return {
      'total': totalVaccinations,
      'dogs': dogsVaccinated,
      'cats': catsVaccinated,
    };
  }

  // Eliminar vacunación
  Future<void> deleteVaccination(String id) async {
    await _supabaseService.vaccinationsTable.delete().eq('id', id);
  }
}
