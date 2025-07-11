import 'package:app_for_test_example/core/providers/sqlite/db_helper.dart';
import 'package:app_for_test_example/feartures/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_local_datasource_provider.g.dart';

@riverpod
TodoLocalDatasource todoLocalDataSource(Ref ref){
  final dbHelper = ref.watch(dbHelperProvider);
  return TodoLocalDataSourceImpl(dbHelper: dbHelper);
}