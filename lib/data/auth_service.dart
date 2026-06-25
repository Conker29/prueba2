import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';
import '../core/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UsuarioModel?> login(String correo, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: correo,
      password: password,
    );
    return await obtenerUsuario(cred.user!.uid);
  }

  Future<UsuarioModel?> obtenerUsuario(String uid) async {
    final doc = await _db.collection(FirestoreCollections.usuarios).doc(uid).get();
    if (doc.exists) return UsuarioModel.fromMap(doc.data()!);
    return null;
  }

  Future<void> cambiarPassword(String nuevaPassword) async {
    await _auth.currentUser!.updatePassword(nuevaPassword);
    await _db
        .collection(FirestoreCollections.usuarios)
        .doc(_auth.currentUser!.uid)
        .update({'debeCambiarPassword': false});
  }

  Future<void> recuperarPassword(String correo) async {
    await _auth.sendPasswordResetEmail(email: correo);
  }

  Future<void> logout() async => _auth.signOut();
}