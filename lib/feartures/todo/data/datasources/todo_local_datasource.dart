import 'package:app_for_test_example/core/error/exceptions.dart';
import 'package:app_for_test_example/core/providers/sqlite/db_helper.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

abstract class TodoLocalDatasource {

  ///Gets the cached [Todo] wich was previously stored
  ///Throws a [NoLocalDataException] if no cached data is presented
  Future<TodoModel> getTodo(int id);

  ///Gets the cached [List] of [Todo] wich was previously stored
  ///Throws a [NoLocalDataException] if no cached data is presented
  Future<List<TodoModel>> getAllTodos();

  Future<bool> saveTodo(TodoModel todo);
}

class TodoLocalDataSourceImpl extends TodoLocalDatasource {

  final IDBHelper dbHelper;
  late final Future<Database> _dbFuture;

  TodoLocalDataSourceImpl({required this.dbHelper}) {
    _dbFuture = dbHelper.initDB();
  }

  static const todosTable = 'Todos';

  @override
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final db = await _dbFuture;
      final todosMap = await db.rawQuery("SELECT * FROM $todosTable");
      if (todosMap.isEmpty) throw NoLocalDataException();
      return todosMap.map((map) => TodoModel.fromJson(map)).toList();
    }on NoLocalDataException{
      rethrow;
    }catch (e) {
      throw LocalDataException();
    }
  }

  @override
  Future<TodoModel> getTodo(int id) async {
    try {
      final db = await _dbFuture;
      final todosMap = await db.query(
        todosTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (todosMap.isEmpty) throw NoLocalDataException();
      return TodoModel.fromJson(todosMap.first as Map<String, dynamic>);
    } on NoLocalDataException {
      rethrow; 
    } catch (e) {
      throw LocalDataException();
    }
  }

  @override
  Future<bool> saveTodo(TodoModel todo) async {
    try {
      final db = await _dbFuture;
      final id = await db.insert(todosTable, todo.toJson());
      return id > 0;
    } catch (e) {
      debugPrint(e.toString());
      throw LocalDataException();
    }
  }
}







