import 'dart:convert';

import 'package:app_for_test_example/feartures/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:app_for_test_example/core/error/exceptions.dart';
import 'package:app_for_test_example/core/error/failure.dart';
import 'package:app_for_test_example/feartures/todo/data/datasources/todo_local_datasource.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';

import '../../../../fixtures/fixture.dart';
import 'todo_repository_impl_test.mocks.dart';

@GenerateMocks([TodoLocalDatasource])
void main() {
  late MockTodoLocalDatasource mockDatasource;
  late TodoRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockTodoLocalDatasource();
    repository = TodoRepositoryImpl(todoLocalDatasource: mockDatasource);
  });

  final testTodoMap = json.decode(fixture('todo_true.json')) as Map<String, dynamic>;
  final testTodo = TodoModel.fromJson(testTodoMap);
  final testTodoList = [testTodo];

  group('getTodo', (){
    test('should return Right(Todo) when datasource returns a todo', () async {
      when(mockDatasource.getTodo(1)).thenAnswer((_) async => testTodo);

      final result = await repository.getTodo(1);

      expect(result, Right(testTodo));
    });

    test('should return Left(CacheFailure) when datasource throws NoLocalDataException', () async {
      when(mockDatasource.getTodo(1)).thenThrow(NoLocalDataException());

      final result = await repository.getTodo(1);

      expect(result, Left(CacheFailure()));
    });

    test('should return Left(CacheFailure) when datasource throws LocalDataException in getTodo', () async {
      when(mockDatasource.getTodo(1)).thenThrow(LocalDataException());

      final result = await repository.getTodo(1);

      expect(result, Left(CacheFailure()));
    });

    
  });


  group('getAllTodos', (){
    test('should return Right(List<Todo>) when datasource returns todos', () async {
      when(mockDatasource.getAllTodos()).thenAnswer((_) async => testTodoList);

      final result = await repository.getAllTodos();

      expect(result, Right(testTodoList));
    });

    test('should return Left(CacheFailure) when datasource throws NoLocalDataException in getAllTodos', () async {
      when(mockDatasource.getAllTodos()).thenThrow(NoLocalDataException());

      final result = await repository.getAllTodos();

      expect(result, Left(CacheFailure()));
    });


    test('should return Left(CacheFailure) when datasource throws LocalDataException', () async {
      when(mockDatasource.getAllTodos()).thenThrow(LocalDataException());

      final result = await repository.getAllTodos();

      expect(result, Left(CacheFailure()));
    });

  });

  group('saveTodo', (){
    test('should return Right(true) when save is successful', () async {
      when(mockDatasource.saveTodo(testTodo)).thenAnswer((_) async => true);

      final result = await repository.saveTodo(testTodo);

      expect(result, Right(true));
    });

    test('should return Left(CacheFailure) when save fails', () async {
      when(mockDatasource.saveTodo(testTodo)).thenAnswer((_) async => false);

      final result = await repository.saveTodo(testTodo);

      expect(result, Left(CacheFailure()));
    });

    test('should return Left(CacheFailure) when datasource throws exception', () async {
      when(mockDatasource.saveTodo(testTodo)).thenThrow(LocalDataException());

      final result = await repository.saveTodo(testTodo);

      expect(result, Left(CacheFailure()));
    });

  });

  




}
