import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/usuario_service.dart';
import '../models/usuario_model.dart';
import '../firebase_options.dart';

enum EstadoUI { inicial, cargando, exito, error }

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  EstadoUI estado = EstadoUI.inicial;
  String? mensajeError;

  Future<bool> crearUsuario(UsuarioModel usuario) async {
    estado = EstadoUI.cargando;
    notifyListeners();

    FirebaseApp? secondary;
    try {
      // App secundaria para no perder la sesión del coordinador
      secondary = await Firebase.initializeApp(
        name: 'SecondaryApp-${DateTime.now().millisecondsSinceEpoch}',
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await _service.crearUsuario(secondaryApp: secondary, usuario: usuario);

      estado = EstadoUI.exito;
      notifyListeners();
      return true;
    } catch (e) {
      mensajeError = e.toString();
      estado = EstadoUI.error;
      notifyListeners();
      return false;
    } finally {
      await secondary?.delete();
    }
  }

  Stream<List<UsuarioModel>> obtenerPorRol(String rol) =>
      _service.obtenerPorRol(rol);

  Stream<List<UsuarioModel>> vacunadoresDe(String creadorUid) =>
      _service.vacunadoresPorCreador(creadorUid);

  Future<void> asignarSectores(String uid, List<String> sectores) =>
      _service.asignarSectores(uid, sectores);
}

class DefaultFirebaseOptions {
}