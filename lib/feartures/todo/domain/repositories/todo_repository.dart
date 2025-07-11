import 'package:app_for_test_example/core/error/failure.dart';
import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {

  Future<Either<Failure, Todo>> getTodo(int id);

  Future<Either<Failure, List<Todo>>> getAllTodos();

  Future<Either<Failure, bool>> saveTodo(Todo todo);
}