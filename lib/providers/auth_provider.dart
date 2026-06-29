import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  UsuarioModel? usuario;
  bool cargando = true;
  String? error;

  AuthProvider() {
    _cargarSesion();
  }

  Future<void> _cargarSesion() async {
    final actual = _service.currentUser;
    if (actual != null) {
      usuario = await _service.obtenerUsuario(actual.uid);
    }
    cargando = false;
    notifyListeners();
  }

  Future<bool> login(String correo, String password) async {
    try {
      cargando = true;
      error = null;
      notifyListeners();
      usuario = await _service.login(correo, password);
      cargando = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = 'Credenciales incorrectas';
      cargando = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cambiarPassword(String nueva) async {
    try {
      await _service.cambiarPassword(nueva);
      usuario = await _service.obtenerUsuario(_service.currentUser!.uid);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> recuperarPassword(String correo) =>
      _service.recuperarPassword(correo);

  Future<void> logout() async {
    await _service.logout();
    usuario = null;
    notifyListeners();
  }
}