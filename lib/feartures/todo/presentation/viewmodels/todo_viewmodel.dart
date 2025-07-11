import 'package:app_for_test_example/core/error/failure.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/data/providers/todo_repository_provider.dart';
import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';
import 'package:app_for_test_example/feartures/todo/domain/repositories/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_viewmodel.g.dart';

class TodosState {
  final List<Todo> todos;
  final Failure? error;
  final bool isLoading;

  TodosState({
    required this.todos,
    this.error,
    this.isLoading = false,
  });

  factory TodosState.initial() => TodosState(todos: []);

  TodosState copyWith({
    List<Todo>? todos,
    Failure? error,
    bool? isLoading,
  }) {
    return TodosState(
      todos: todos ?? this.todos,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}




@riverpod
class TodoViewModel extends _$TodoViewModel {
  
  late final TodoRepository _todoRepository;

  @override
  TodosState build() {
    _todoRepository = ref.watch(todoRepositoryProvider);
    return TodosState.initial();
  }

  Future<void> getAllTodos() async {
    state = state.copyWith(isLoading: true, error: null);
    final todosResult = await _todoRepository.getAllTodos();
    todosResult.fold(
      (failure) => state = state.copyWith(error: failure, isLoading: false),
      (todos) => state = state.copyWith(todos: todos, isLoading: false, error: null),
    );
  }

  Future<void> saveTodo(TodoModel todo) async {
    final saved = await _todoRepository.saveTodo(todo);
    saved.fold(
      (failure) => state = state.copyWith(error: failure),
      (_) async => await getAllTodos(),
    );
  }
}
