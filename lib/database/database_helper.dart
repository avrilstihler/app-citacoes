import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/citacao_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'citacoes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE citacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        texto TEXT,
        fonte TEXT,
        isFavorito INTEGER
      )
    ''');
  }

  Future<int> insertCitacao(Citacao citacao) async {
    Database db = await database;
    return await db.insert('citacoes', citacao.toMap());
  }

  Future<List<Citacao>> getCitacoes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('citacoes');
    return List.generate(maps.length, (i) {
      return Citacao.fromMap(maps[i]);
    });
  }

  Future<int> updateCitacao(Citacao citacao) async {
    Database db = await database;
    return await db.update(
      'citacoes',
      citacao.toMap(),
      where: 'id = ?',
      whereArgs: [citacao.id],
    );
  }

  Future<int> deleteCitacao(int id) async {
    Database db = await database;
    return await db.delete(
      'citacoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}