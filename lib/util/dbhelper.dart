import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {
  String tblTodo = 'todo';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  // --------singleton pattern in dart------------

  // 1) create an empty private named constructor
  DbHelper._internal();

  // 2) create a private instance of the class
  static final DbHelper _dbHelper = DbHelper._internal();

  // 3) use the factory to always return the same instance
  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todos.db';
    Database dbTodos =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $tblTodo(' +
        '$colId INTEGER PRIMARY KEY, ' +
        '$colTitle TEXT, ' +
        '$colDescription TEXT, ' +
        '$colPriority INTEGER, ' +
        '$colDate TEXT' +
        ')');
  }

  // crud operations
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result =
        await db.rawQuery('SELECT * FROM $tblTodo ORDER BY $colPriority ASC');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) FROM $tblTodo'));
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblTodo WHERE $colId = $id');
    return result;
  }
}
