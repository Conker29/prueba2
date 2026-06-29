import 'package:flutter/material.dart';
import '../data/usuario_service.dart';
import '../models/usuario_model.dart';

enum EstadoUI { inicial, cargando, exito, error }

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  EstadoUI estado = EstadoUI.inicial;
  String? mensajeError;

  Future<bool> crearUsuario(UsuarioModel usuario) async {
    estado = EstadoUI.cargando;
    notifyListeners();

    try {
      await _service.crearUsuario(usuario: usuario, secondaryApp: null);
      estado = EstadoUI.exito;
      notifyListeners();
      return true;
    } catch (e) {
      mensajeError = e.toString();
      estado = EstadoUI.error;
      notifyListeners();
      return false;
    }
  }

  Stream<List<UsuarioModel>> obtenerPorRol(String rol) =>
      _service.obtenerPorRol(rol);

  Stream<List<UsuarioModel>> vacunadoresDe(String creadorUid) =>
      _service.vacunadoresPorCreador(creadorUid);

  Future<void> asignarSectores(String uid, List<String> sectores) =>
      _service.asignarSectores(uid, sectores);
}
