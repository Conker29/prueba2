class SectorModel {
  final String id;
  final String nombre;
  final String? coordinadorBrigadaUid;

  SectorModel({
    required this.id,
    required this.nombre,
    this.coordinadorBrigadaUid,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'coordinadorBrigadaUid': coordinadorBrigadaUid,
      };

  factory SectorModel.fromMap(Map<String, dynamic> map) => SectorModel(
        id: map['id'] ?? '',
        nombre: map['nombre'] ?? '',
        coordinadorBrigadaUid: map['coordinadorBrigadaUid'],
      );
}