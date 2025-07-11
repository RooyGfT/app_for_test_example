import 'package:app_for_test_example/feartures/todo/data/providers/todo_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_for_test_example/core/error/failure.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';
import 'package:app_for_test_example/feartures/todo/domain/repositories/todo_repository.dart';
import 'package:app_for_test_example/feartures/todo/presentation/screen/todos_screen.dart';
import 'package:dartz/dartz.dart';

/// Fake repository para simular respuestas del dominio
class FakeTodoRepository implements TodoRepository {
  final List<TodoModel> fakeTodos;
  final Failure? failureOnGet;
  final Failure? failureOnSave;

  FakeTodoRepository({
    this.fakeTodos = const [],
    this.failureOnGet,
    this.failureOnSave,
  });

  @override
  Future<Either<Failure, List<TodoModel>>> getAllTodos() async {
    if (failureOnGet != null) return Left(failureOnGet!);
    return Right(fakeTodos);
  }

  @override
  Future<Either<Failure, bool>> saveTodo(Todo todo) async {
    await Future.delayed(Duration(seconds: 2));
    if (failureOnSave != null) return Left(failureOnSave!);
    return Right(true);
  }

  @override
  Future<Either<Failure, TodoModel>> getTodo(int id) async {
    return Right(fakeTodos.firstWhere((t) => t.id == id));
  }
}

void main() {

  testWidgets('should show todos list when loaded', (tester) async {
    final todos = [
      TodoModel(id: 1, description: 'Test Todo', done: false),
    ];

    final override = todoRepositoryProvider.overrideWithValue(
      FakeTodoRepository(fakeTodos: todos),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: const MaterialApp(home: TodosScreen()),
      ),
    );

    await tester.pumpAndSettle(); // espera a que se complete la carga

    expect(find.text('Test Todo'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });

  testWidgets('should show error message when error exists', (tester) async {
    final override = todoRepositoryProvider.overrideWithValue(
      FakeTodoRepository(failureOnGet: CacheFailure()),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: const MaterialApp(home: TodosScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Error:'), findsOneWidget);
  });
}
