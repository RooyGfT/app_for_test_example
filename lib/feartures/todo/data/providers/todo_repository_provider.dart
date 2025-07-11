import 'package:app_for_test_example/feartures/todo/data/providers/todo_local_datasource_provider.dart';
import 'package:app_for_test_example/feartures/todo/data/repositories/todo_repository_impl.dart';
import 'package:app_for_test_example/feartures/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository_provider.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) {
  final todoLocalDataSource = ref.watch(todoLocalDataSourceProvider);
  return TodoRepositoryImpl(todoLocalDatasource: todoLocalDataSource);
}