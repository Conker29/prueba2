class UsuarioModel {
  final String uid;
  final String cedula;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String correo;
  final String rol;
  final List<String> sectoresAsignados;
  final bool debeCambiarPassword;
  final String? creadoPor;

  UsuarioModel({
    required this.uid,
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.correo,
    required this.rol,
    this.sectoresAsignados = const [],
    this.debeCambiarPassword = true,
    this.creadoPor,
  });

  String get nombreCompleto => '$nombres $apellidos';

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'cedula': cedula,
        'nombres': nombres,
        'apellidos': apellidos,
        'telefono': telefono,
        'correo': correo,
        'rol': rol,
        'sectoresAsignados': sectoresAsignados,
        'debeCambiarPassword': debeCambiarPassword,
        'creadoPor': creadoPor,
      };

  factory UsuarioModel.fromMap(Map<String, dynamic> map) => UsuarioModel(
        uid: map['uid'] ?? '',
        cedula: map['cedula'] ?? '',
        nombres: map['nombres'] ?? '',
        apellidos: map['apellidos'] ?? '',
        telefono: map['telefono'] ?? '',
        correo: map['correo'] ?? '',
        rol: map['rol'] ?? '',
        sectoresAsignados: List<String>.from(map['sectoresAsignados'] ?? []),
        debeCambiarPassword: map['debeCambiarPassword'] ?? true,
        creadoPor: map['creadoPor'],
      );
}