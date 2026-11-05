import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/tarea.dart';

class LocalDatabase {
  static Database? _instance;

  Future<Database> get database async {
    if (_instance != null) return _instance!;
    _instance = await _abrirBD();
    return _instance!;
  }

  Future<Database> _abrirBD() async {
    final directorio = await getDatabasesPath();
    final ruta = join(directorio, 'cartilla_app.db');

    return openDatabase(
      ruta,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tareas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT,
            completada INTEGER NOT NULL DEFAULT 0,
            prioridad TEXT NOT NULL DEFAULT 'normal',
            fecha TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertar(Tarea tarea) async {
    final db = await database;
    return await db.insert(
      'tareas',
      tarea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tarea>> obtenerTodas() async {
    final db = await database;
    final maps = await db.query('tareas', orderBy: 'id DESC');
    return maps.map((map) => Tarea.fromMap(map)).toList();
  }

  Future<List<Tarea>> obtenerPorEstado(bool completadas) async {
    final db = await database;
    final maps = await db.query(
      'tareas',
      where: 'completada = ?',
      whereArgs: [completadas ? 1 : 0],
      orderBy: 'id DESC',
    );
    return maps.map((m) => Tarea.fromMap(m)).toList();
  }

  Future<int> actualizar(Tarea tarea) async {
    final db = await database;
    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await database;
    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
