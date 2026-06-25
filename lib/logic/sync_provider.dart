import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/local_db.dart';
import '../data/vacunacion_service.dart';
import '../data/storage_service.dart';

class SyncProvider extends ChangeNotifier {
  final LocalDB _local = LocalDB.instance;
  final VacunacionService _service = VacunacionService();
  final StorageService _storage = StorageService();

  int pendientes = 0;
  bool sincronizando = false;

  Future<void> actualizarContador() async {
    pendientes = await _local.contarPendientes();
    notifyListeners();
  }

  /// Sube los registros pendientes cuando hay conexión
  Future<void> sincronizar() async {
    final con = await Connectivity().checkConnectivity();
    if (con.contains(ConnectivityResult.none)) return;

    sincronizando = true;
    notifyListeners();

    final lista = await _local.obtenerPendientes();
    for (final v in lista) {
      try {
        String url = v.fotoUrl;
        if (!url.startsWith('http')) {
          url = await _storage.subirFoto(File(v.fotoUrl), v.id);
        }
        final remoto = v.copyWith(fotoUrl: url, sincronizado: true);
        await _service.guardar(remoto);
        await _local.marcarSincronizado(v.id, url);
      } catch (_) {
        // se reintentará luego
      }
    }

    sincronizando = false;
    await actualizarContador();
  }
}