import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'notas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            contenido TEXT NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Insertar nota
  Future<int> insertNota(Map<String, dynamic> nota) async {
    final db = await database;
    return await db.insert('notas', nota);
  }

  // Obtener todas las notas
  Future<List<Map<String, dynamic>>> getNotas() async {
    final db = await database;
    return await db.query('notas', orderBy: 'fecha DESC');
  }

  // Actualizar nota
  Future<int> updateNota(Map<String, dynamic> nota) async {
    final db = await database;
    return await db.update(
      'notas',
      nota,
      where: 'id = ?',
      whereArgs: [nota['id']],
    );
  }

  // Eliminar nota
  Future<int> deleteNota(int id) async {
    final db = await database;
    return await db.delete(
      'notas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
