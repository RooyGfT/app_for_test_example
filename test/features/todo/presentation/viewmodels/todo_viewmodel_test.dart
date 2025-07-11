import 'dart:convert';

import 'package:app_for_test_example/core/error/failure.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/data/providers/todo_repository_provider.dart';
import 'package:app_for_test_example/feartures/todo/domain/repositories/todo_repository.dart';
import 'package:app_for_test_example/feartures/todo/presentation/viewmodels/todo_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture.dart';
import 'todo_viewmodel_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockRepository;
  late ProviderContainer container;
  late TodoModel testTodo;
  late List<TodoModel> testTodos;

  setUp(() {
    mockRepository = MockTodoRepository();
    container = ProviderContainer(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );

    final testTodoMap = json.decode(fixture('todo_false.json'));
    testTodo = TodoModel.fromJson(testTodoMap);
    testTodos = [testTodo];
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state should be TodosState with empty list, no error, and not loading', () {
    final viewModel = container.read(todoViewModelProvider.notifier);
    final state = viewModel.state;

    expect(state.todos, isEmpty);
    expect(state.error, isNull);
    expect(state.isLoading, isFalse);
  });

  test('getAllTodos should update state with todos when successful', () async {
    when(mockRepository.getAllTodos()).thenAnswer((_) async => Right(testTodos));

    final viewModel = container.read(todoViewModelProvider.notifier);
    await viewModel.getAllTodos();

    final state = viewModel.state;
    expect(state.todos, testTodos);
    expect(state.error, isNull);
    expect(state.isLoading, isFalse);
  });

  test('getAllTodos should update state with error when failure occurs', () async {
    final failure = CacheFailure();
    when(mockRepository.getAllTodos()).thenAnswer((_) async => Left(failure));

    final viewModel = container.read(todoViewModelProvider.notifier);
    await viewModel.getAllTodos();

    final state = viewModel.state;
    expect(state.todos, isEmpty);
    expect(state.error, failure);
    expect(state.isLoading, isFalse);
  });

  test('saveTodo should call getAllTodos when save is successful', () async {
    when(mockRepository.saveTodo(testTodo)).thenAnswer((_) async => Right(true));
    when(mockRepository.getAllTodos()).thenAnswer((_) async => Right(testTodos));

    final viewModel = container.read(todoViewModelProvider.notifier);
    await viewModel.saveTodo(testTodo);

    await untilCalled(mockRepository.getAllTodos());

    final state = viewModel.state;
    print("VIEWMODEL: ${state.todos}");
    print("VIEWMODEL: ${state.error}");
    print("VIEWMODEL: ${state.isLoading}");

    expect(state.todos, testTodos);
    expect(state.error, isNull);
    expect(state.isLoading, isFalse);
  });


  test('saveTodo should update error when save fails', () async {
    final failure = CacheFailure();
    when(mockRepository.saveTodo(testTodo)).thenAnswer((_) async => Left(failure));

    final viewModel = container.read(todoViewModelProvider.notifier);
    await viewModel.saveTodo(testTodo);

    final state = viewModel.state;
    expect(state.error, failure);
    expect(state.todos, isEmpty);
  });
}
