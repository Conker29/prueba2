import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';
import '../core/constants.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crea un usuario en Auth + Firestore.
  /// NOTA: createUserWithEmailAndPassword cambia la sesión activa.
  /// Para producción se recomienda Cloud Functions / Admin SDK.
  /// Aquí usamos una app secundaria de Firebase para no perder la sesión.
  Future<void> crearUsuario({
    required FirebaseApp secondaryApp,
    required UsuarioModel usuario,
  }) async {
    final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
    final cred = await secondaryAuth.createUserWithEmailAndPassword(
      email: usuario.correo,
      password: passwordInicial,
    );

    final nuevo = UsuarioModel(
      uid: cred.user!.uid,
      cedula: usuario.cedula,
      nombres: usuario.nombres,
      apellidos: usuario.apellidos,
      telefono: usuario.telefono,
      correo: usuario.correo,
      rol: usuario.rol,
      sectoresAsignados: usuario.sectoresAsignados,
      debeCambiarPassword: true,
      creadoPor: usuario.creadoPor,
    );

    await _db
        .collection(FirestoreCollections.usuarios)
        .doc(cred.user!.uid)
        .set(nuevo.toMap());

    await secondaryAuth.signOut();
  }

  Stream<List<UsuarioModel>> obtenerPorRol(String rol) {
    return _db
        .collection(FirestoreCollections.usuarios)
        .where('rol', isEqualTo: rol)
        .snapshots()
        .map((s) => s.docs.map((d) => UsuarioModel.fromMap(d.data())).toList());
  }

  Stream<List<UsuarioModel>> vacunadoresPorCreador(String creadorUid) {
    return _db
        .collection(FirestoreCollections.usuarios)
        .where('rol', isEqualTo: Roles.vacunador)
        .where('creadoPor', isEqualTo: creadorUid)
        .snapshots()
        .map((s) => s.docs.map((d) => UsuarioModel.fromMap(d.data())).toList());
  }

  Future<void> asignarSectores(String uid, List<String> sectores) async {
    await _db
        .collection(FirestoreCollections.usuarios)
        .doc(uid)
        .update({'sectoresAsignados': sectores});
  }
}