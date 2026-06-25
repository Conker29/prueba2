import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sector_model.dart';
import '../core/constants.dart';

class SectorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> crearSector(SectorModel sector) async {
    await _db
        .collection(FirestoreCollections.sectores)
        .doc(sector.id)
        .set(sector.toMap());
  }

  /// Precarga los sectores iniciales si no existen
  Future<void> precargarSectores(List<String> nombres) async {
    final col = _db.collection(FirestoreCollections.sectores);
    final existentes = await col.get();
    if (existentes.docs.isEmpty) {
      for (final nombre in nombres) {
        final doc = col.doc();
        await doc.set(SectorModel(id: doc.id, nombre: nombre).toMap());
      }
    }
  }

  Stream<List<SectorModel>> obtenerSectores() {
    return _db.collection(FirestoreCollections.sectores).snapshots().map(
        (s) => s.docs.map((d) => SectorModel.fromMap(d.data())).toList());
  }

  Future<void> asignarCoordinador(String sectorId, String coordUid) async {
    await _db
        .collection(FirestoreCollections.sectores)
        .doc(sectorId)
        .update({'coordinadorBrigadaUid': coordUid});
  }
}