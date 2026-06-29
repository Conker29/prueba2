import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/vacunacion_service.dart';
import '../services/storage_service.dart';
import '../services/local_db.dart';
import '../models/vacunacion_model.dart';

class VacunacionProvider extends ChangeNotifier {
  final VacunacionService _service = VacunacionService();
  final StorageService _storage = StorageService();
  final LocalDB _local = LocalDB.instance;

  EstadoUI estado = EstadoUI.inicial;
  String? error;

  /// Registra una vacunación: guarda local SIEMPRE,
  /// luego intenta subir a la nube si hay conexión.
  Future<bool> registrar(VacunacionModel v, File foto) async {
    estado = EstadoUI.cargando;
    notifyListeners();
    try {
      // 1. Guardar local (offline-first)
      final local = v.copyWith(fotoUrl: foto.path, sincronizado: false);
      await _local.guardar(local);

      // 2. Verificar conexión
      final con = await Connectivity().checkConnectivity();
      final hayInternet = !con.contains(ConnectivityResult.none);

      if (hayInternet) {
        final url = await _storage.subirFoto(foto, v.id);
        final remoto = v.copyWith(fotoUrl: url, sincronizado: true);
        await _service.guardar(remoto);
        await _local.marcarSincronizado(v.id, url);
      }

      estado = EstadoUI.exito;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      estado = EstadoUI.error;
      notifyListeners();
      return false;
    }
  }

  String nuevoId() => const Uuid().v4();

  Stream<List<VacunacionModel>> todas() => _service.todas();
  Stream<List<VacunacionModel>> porSector(List<String> s) =>
      _service.porSector(s);
  Stream<List<VacunacionModel>> porVacunador(String uid) =>
      _service.porVacunador(uid);
}

enum EstadoUI { inicial, cargando, exito, error }