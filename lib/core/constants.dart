class Roles {
  static const coordinadorCampana = 'coordinador_campana';
  static const coordinadorBrigada = 'coordinador_brigada';
  static const vacunador = 'vacunador';
}

class FirestoreCollections {
  static const usuarios = 'usuarios';
  static const sectores = 'sectores';
  static const vacunaciones = 'vacunaciones';
}

const String passwordInicial = 'Ecuador2026';

// Sectores precargados (ejemplo - ciudad de Quito)
const List<String> sectoresPrecargados = [
  'La Mariscal',
  'La Floresta',
  'El Batán',
  'Cumbayá',
  'Tumbaco',
  'Carapungo',
  'Calderón',
  'El Inca',
];