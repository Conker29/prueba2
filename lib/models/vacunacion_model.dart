class VacunacionModel {
  final String id;
  final String propietarioNombre;
  final String propietarioCedula;
  final String telefono;
  final String tipoMascota; // perro / gato
  final String nombreMascota;
  final String edad;
  final String sexo;
  final String vacunaAplicada;
  final String observaciones;
  final String fotoUrl;       // url remota o ruta local
  final double latitud;
  final double longitud;
  final DateTime fechaHora;
  final String sector;
  final String vacunadorUid;
  final String vacunadorNombre;
  final bool sincronizado;

  VacunacionModel({
    required this.id,
    required this.propietarioNombre,
    required this.propietarioCedula,
    required this.telefono,
    required this.tipoMascota,
    required this.nombreMascota,
    required this.edad,
    required this.sexo,
    required this.vacunaAplicada,
    required this.observaciones,
    required this.fotoUrl,
    required this.latitud,
    required this.longitud,
    required this.fechaHora,
    required this.sector,
    required this.vacunadorUid,
    required this.vacunadorNombre,
    this.sincronizado = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'propietarioNombre': propietarioNombre,
        'propietarioCedula': propietarioCedula,
        'telefono': telefono,
        'tipoMascota': tipoMascota,
        'nombreMascota': nombreMascota,
        'edad': edad,
        'sexo': sexo,
        'vacunaAplicada': vacunaAplicada,
        'observaciones': observaciones,
        'fotoUrl': fotoUrl,
        'latitud': latitud,
        'longitud': longitud,
        'fechaHora': fechaHora.toIso8601String(),
        'sector': sector,
        'vacunadorUid': vacunadorUid,
        'vacunadorNombre': vacunadorNombre,
        'sincronizado': sincronizado ? 1 : 0,
      };

  factory VacunacionModel.fromMap(Map<String, dynamic> map) => VacunacionModel(
        id: map['id'] ?? '',
        propietarioNombre: map['propietarioNombre'] ?? '',
        propietarioCedula: map['propietarioCedula'] ?? '',
        telefono: map['telefono'] ?? '',
        tipoMascota: map['tipoMascota'] ?? '',
        nombreMascota: map['nombreMascota'] ?? '',
        edad: map['edad'] ?? '',
        sexo: map['sexo'] ?? '',
        vacunaAplicada: map['vacunaAplicada'] ?? '',
        observaciones: map['observaciones'] ?? '',
        fotoUrl: map['fotoUrl'] ?? '',
        latitud: (map['latitud'] ?? 0).toDouble(),
        longitud: (map['longitud'] ?? 0).toDouble(),
        fechaHora: DateTime.parse(map['fechaHora']),
        sector: map['sector'] ?? '',
        vacunadorUid: map['vacunadorUid'] ?? '',
        vacunadorNombre: map['vacunadorNombre'] ?? '',
        sincronizado: (map['sincronizado'] == 1 || map['sincronizado'] == true),
      );

  VacunacionModel copyWith({String? fotoUrl, bool? sincronizado}) =>
      VacunacionModel(
        id: id,
        propietarioNombre: propietarioNombre,
        propietarioCedula: propietarioCedula,
        telefono: telefono,
        tipoMascota: tipoMascota,
        nombreMascota: nombreMascota,
        edad: edad,
        sexo: sexo,
        vacunaAplicada: vacunaAplicada,
        observaciones: observaciones,
        fotoUrl: fotoUrl ?? this.fotoUrl,
        latitud: latitud,
        longitud: longitud,
        fechaHora: fechaHora,
        sector: sector,
        vacunadorUid: vacunadorUid,
        vacunadorNombre: vacunadorNombre,
        sincronizado: sincronizado ?? this.sincronizado,
      );
}