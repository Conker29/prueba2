import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vacunacion_model.dart';
import '../core/constants.dart';

class VacunacionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> guardar(VacunacionModel v) async {
    await _db
        .collection(FirestoreCollections.vacunaciones)
        .doc(v.id)
        .set(v.copyWith(sincronizado: true).toMap());
  }

  Stream<List<VacunacionModel>> todas() {
    return _db.collection(FirestoreCollections.vacunaciones).snapshots().map(
        (s) => s.docs.map((d) => VacunacionModel.fromMap(d.data())).toList());
  }

  Stream<List<VacunacionModel>> porSector(List<String> sectores) {
    if (sectores.isEmpty) {
      return const Stream.empty();
    }
    return _db
        .collection(FirestoreCollections.vacunaciones)
        .where('sector', whereIn: sectores)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => VacunacionModel.fromMap(d.data())).toList());
  }

  Stream<List<VacunacionModel>> porVacunador(String uid) {
    return _db
        .collection(FirestoreCollections.vacunaciones)
        .where('vacunadorUid', isEqualTo: uid)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => VacunacionModel.fromMap(d.data())).toList());
  }
}