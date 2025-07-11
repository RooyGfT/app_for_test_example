import 'dart:convert';

import 'package:app_for_test_example/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'package:app_for_test_example/core/providers/sqlite/db_helper.dart';
import 'package:app_for_test_example/feartures/todo/data/datasources/todo_local_datasource.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';

import '../../../../fixtures/fixture.dart';
import 'todo_local_datasource_test.mocks.dart';

@GenerateMocks([DBHelper, Database])
void main() {
  late MockDBHelper mockDBHelper;
  late MockDatabase mockDatabase;
  late TodoLocalDataSourceImpl datasource;

  setUp(() {
    mockDBHelper = MockDBHelper();
    mockDatabase = MockDatabase();
    when(mockDBHelper.initDB()).thenAnswer((_) async => mockDatabase);
    datasource = TodoLocalDataSourceImpl(dbHelper: mockDBHelper);
    
  });

  final testTodoMap = json.decode(fixture('todo_true.json')) as Map<String, dynamic>;
  final testTodo = TodoModel.fromJson(testTodoMap);

  group('getTodo', () {

    test('should return TodoModel when data is found in the database', () async {
      // Arrange
      when(mockDatabase.query(
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenAnswer((_) async => [testTodoMap]);

      // Act
      final result = await datasource.getTodo(1);

      // Assert
      expect(result, equals(testTodo));
    });

    test('should throw NoLocalDataException when no todo is found', () async {
      when(mockDBHelper.initDB()).thenAnswer((_) async => mockDatabase);
      when(mockDatabase.query(
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenAnswer((_) async => []);

      expect(() => datasource.getTodo(1), throwsA(isA<NoLocalDataException>()));
    });

    test('should throw LocalDataException when an unexpected error occurs', () async {
      when(mockDBHelper.initDB()).thenThrow(Exception('DB error'));

      expect(() => datasource.getTodo(1), throwsA(isA<LocalDataException>()));
    });

  });


  group('getAllTodos', () {
    test('should return list of TodoModel when data is found in the database', () async {
      // Arrange
      final testTodos = [testTodoMap];

      when(mockDBHelper.initDB()).thenAnswer((_) async => mockDatabase);
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => testTodos);

      // Act
      final result = await datasource.getAllTodos();

      // Assert
      expect(result, isA<List<TodoModel>>());
      expect(result.first.id, testTodoMap['id']);
    });

    test('should throw NoLocalDataException when getAllTodos returns empty list', () async {
      when(mockDBHelper.initDB()).thenAnswer((_) async => mockDatabase);
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => []);

      expect(() => datasource.getAllTodos(), throwsA(isA<NoLocalDataException>()));
    });

    test('should throw LocalDataException when an unexpected error occurs', () async {
      when(mockDBHelper.initDB()).thenThrow(Exception('DB error'));

      expect(() => datasource.getAllTodos(), throwsA(isA<LocalDataException>()));
    });



  });

  group('saveTodo', () {
    test('should return true when insert is successful', () async {

      when(mockDBHelper.initDB()).thenAnswer((_) async => mockDatabase);
      when(mockDatabase.insert(any, any)).thenAnswer((_) async => 1);

      // Act
      final result = await datasource.saveTodo(testTodo);

      // Assert
      expect(result, isTrue);
    });

    test('should throw LocalDataException when an unexpected error occurs', () async {
      when(mockDBHelper.initDB()).thenThrow(Exception('DB error'));

      expect(() => datasource.saveTodo(testTodo), throwsA(isA<LocalDataException>()));
    });

  });

}
