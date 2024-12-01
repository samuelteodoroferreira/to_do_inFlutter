import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tarefa.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tarefas.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tarefas(id INTEGER PRIMARY KEY, titulo TEXT, estaConcluida INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<List<Tarefa>> buscarTarefas() async {
    final db = await database;
    final maps = await db.query('tarefas');
    if (maps.isNotEmpty) {
      return maps.map((map) => Tarefa.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  Future<int> inserirTarefa(Tarefa tarefa) async {
    final db = await database;
    return db.insert('tarefas', tarefa.toMap());
  }

  Future<int> atualizarTarefa(Tarefa tarefa) async {
    final db = await database;
    return db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> deletarTarefa(int id) async {
    final db = await database;
    return db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
