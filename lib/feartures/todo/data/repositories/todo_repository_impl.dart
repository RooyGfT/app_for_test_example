import 'package:app_for_test_example/core/error/exceptions.dart';
import 'package:app_for_test_example/core/error/failure.dart';
import 'package:app_for_test_example/feartures/todo/data/datasources/todo_local_datasource.dart';
import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';
import 'package:app_for_test_example/feartures/todo/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

class TodoRepositoryImpl extends TodoRepository{

  final TodoLocalDatasource todoLocalDatasource;

  TodoRepositoryImpl({
    required this.todoLocalDatasource
  });

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async{
    try {
      final todos = await todoLocalDatasource.getAllTodos();
      return Right(todos);
    } on NoLocalDataException{
      return Left(CacheFailure());
    } on LocalDataException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodo(int id) async{
    try {
      final todo = await todoLocalDatasource.getTodo(id);
      return Right(todo);
    } on NoLocalDataException{
      return Left(CacheFailure());
    } on LocalDataException {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, bool>> saveTodo(Todo todo) async{
    try {
      final saved = await todoLocalDatasource.saveTodo(todo as TodoModel);
      if(saved){
        return Right(saved);
      }else{
        return Left(CacheFailure());
      }
    } on LocalDataException{
      return Left(CacheFailure());
    }
  }

}