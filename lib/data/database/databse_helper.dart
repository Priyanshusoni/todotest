import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:todo/core/utils/debug_print.dart';
import 'package:todo/domain/models/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  final _dbName = 'test.db';

  /// Creating a database with [_dbName] in your directory. Make sure database is open before get
  Future<void> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    if (_db?.isOpen ?? false) {
      return;
    }
    _db = await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    await initDB();
    return _db!;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Creating tables
  Future<void> _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            todo TEXT,
            completed INTEGER,
            userId INTEGER
          )
        ''');
    printLog("Created tables");
  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {}

  Future<int> insertTodo(TodoModel todo) async {
    final db = await database;
    return db.insert('todos', todo.toMap());
  }

  Future<void> syncBatchTodos(List<TodoModel> todos) async {
    final db = await database;

    final batch = db.batch();

    for (final todo in todos) {
      batch.insert(
        'todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TodoModel>> getTodos({int skip = 0, int limit = 30}) async {
    final db = await database;
    final result = await db.query(
      'todos',
      limit: limit,
      offset: skip,
      orderBy: 'id DESC',
    );
    return result.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> getTodosCount() async {
    final db = await database;

    final result = await db.rawQuery('SELECT COUNT(*) as count FROM todos');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> updateTodo(TodoModel todo) async {
    final db = await database;
    return db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDb() async {
    await _db?.close();
  }
}
