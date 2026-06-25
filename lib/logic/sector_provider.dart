import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/sector_service.dart';
import '../models/sector_model.dart';

class SectorProvider extends ChangeNotifier {
  final SectorService _service = SectorService();

  Future<void> precargar(List<String> nombres) =>
      _service.precargarSectores(nombres);

  Future<void> crearSector(String nombre) async {
    final id = const Uuid().v4();
    await _service.crearSector(SectorModel(id: id, nombre: nombre));
    notifyListeners();
  }

  Stream<List<SectorModel>> obtenerSectores() => _service.obtenerSectores();

  Future<void> asignarCoordinador(String sectorId, String coordUid) async {
    await _service.asignarCoordinador(sectorId, coordUid);
    notifyListeners();
  }
}