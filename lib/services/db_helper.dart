import 'package:sqflite/sqflite.dart';
import '../models/tarefa.dart';
import 'package:path/path.dart';

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
      join(dbPath, 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, titulo TEXT, estaConcluida INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<List<Tarefa>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    if (maps.isNotEmpty) {
      return maps.map((map) => Tarefa.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  Future<List<Tarefa>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tarefas',
      where: 'estaConcluida = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Tarefa(
        id: maps[i]['id'],
        titulo: maps[i]['titulo'],
        estaConcluida: maps[i]['estaConcluida'] == 1,
      );
    });
  }

  Future<int> insertTask(Tarefa task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Tarefa task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
