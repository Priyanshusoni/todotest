import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/core/utils/debug_print.dart';
import 'package:todo/domain/models/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;

  DatabaseHelper._internal();

  final _dbName = 'test.db';
  final _dbVersion = 2;

  /// Creating a database with [_dbName] in your directory. Make sure database is open before get
  Future<void> initDB() async {
    if (_db?.isOpen ?? false) return;

    await Future.delayed(const Duration(milliseconds: 1000));
    // final documentsDirectory = await getApplicationDocumentsDirectory();
    // final path = p.join(documentsDirectory.path, _dbName);
    final path = p.join(
      await getDatabasesPath(), // sqflite native, NOT path_provider
      'todo.db',
    );
    if (_db?.isOpen ?? false) {
      return;
    }
    _db = await openDatabase(
      path,
      version: _dbVersion,
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
    // create sync queue table to store pending operations when offline
    await db.execute('''
          CREATE TABLE sync_queue(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            operation TEXT,
            payload TEXT,
            local_id INTEGER,
            created_at INTEGER
          )
        ''');

    printLog("Created tables");
  }

  // // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS sync_queue(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            operation TEXT,
            payload TEXT,
            local_id INTEGER,
            created_at INTEGER
          )
        ''');
      printLog('Upgraded DB to include sync_queue');
    }
  }

  Future<int> insertTodo(TodoModel todo) async {
    final db = await database;
    return db.insert('todos', todo.toMap());
  }

  Future<int> insertPendingOperation({
    required String operation,
    required Map<String, dynamic> payload,
    required int localId,
  }) async {
    final db = await database;
    return db.insert('sync_queue', {
      'operation': operation,
      'payload': json.encode(payload),
      'local_id': localId,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingOperations() async {
    final db = await database;
    final result = await db.query('sync_queue', orderBy: 'id ASC');
    return result;
  }

  Future<int> deletePendingOperation(int id) async {
    final db = await database;
    return db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTodoId(int oldId, int newId) async {
    final db = await database;
    return db.rawUpdate('UPDATE todos SET id = ? WHERE id = ?', [newId, oldId]);
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

  Future<TodoModel?> getTodoById(int id) async {
    final db = await database;
    final result = await db.query('todos', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return TodoModel.fromMap(result.first);
  }

  Future<void> closeDb() async {
    await _db?.close();
  }
}
