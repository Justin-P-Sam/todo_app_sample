// ignore_for_file: constant_identifier_names, depend_on_referenced_packages

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todoo/model/model_class.dart';

class DatabaseHelper {
  static Database? _database;
  static const String DB_NAME = 'todo.db';
  static const String TABLE_NAME = 'tasks';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_TITLE = 'title';
  static const String COLUMN_COMPLETED = 'completed';

  // Singleton pattern to ensure one database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, DB_NAME);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_NAME(
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_TITLE TEXT,
        $COLUMN_COMPLETED INTEGER
      )
    ''');
  }

  Future<void> insertTask(TodoModel task) async {
    final db = await database;
    await db.insert(TABLE_NAME, task.toMap());
  }

  Future<void> updateTask(TodoModel task) async {
    final db = await database;
    await db.update(
      TABLE_NAME,
      task.toMap(),
      where: '$COLUMN_ID = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      TABLE_NAME,
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }

  Future<List<TodoModel>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }
}
