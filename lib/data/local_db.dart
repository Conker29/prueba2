import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vacunacion_model.dart';

class LocalDB {
  static final LocalDB instance = LocalDB._();
  static Database? _db;
  LocalDB._();

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'vacunacion.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE vacunaciones(
            id TEXT PRIMARY KEY,
            propietarioNombre TEXT,
            propietarioCedula TEXT,
            telefono TEXT,
            tipoMascota TEXT,
            nombreMascota TEXT,
            edad TEXT,
            sexo TEXT,
            vacunaAplicada TEXT,
            observaciones TEXT,
            fotoUrl TEXT,
            latitud REAL,
            longitud REAL,
            fechaHora TEXT,
            sector TEXT,
            vacunadorUid TEXT,
            vacunadorNombre TEXT,
            sincronizado INTEGER
          )
        ''');
      },
    );
  }

  Future<void> guardar(VacunacionModel v) async {
    final db = await database;
    await db.insert('vacunaciones', v.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<VacunacionModel>> obtenerTodas() async {
    final db = await database;
    final maps = await db.query('vacunaciones', orderBy: 'fechaHora DESC');
    return maps.map((m) => VacunacionModel.fromMap(m)).toList();
  }

  Future<List<VacunacionModel>> obtenerPendientes() async {
    final db = await database;
    final maps =
        await db.query('vacunaciones', where: 'sincronizado = 0');
    return maps.map((m) => VacunacionModel.fromMap(m)).toList();
  }

  Future<void> marcarSincronizado(String id, String fotoUrl) async {
    final db = await database;
    await db.update('vacunaciones',
        {'sincronizado': 1, 'fotoUrl': fotoUrl},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> contarPendientes() async {
    final db = await database;
    final r = await db
        .rawQuery('SELECT COUNT(*) c FROM vacunaciones WHERE sincronizado = 0');
    return Sqflite.firstIntValue(r) ?? 0;
  }
}