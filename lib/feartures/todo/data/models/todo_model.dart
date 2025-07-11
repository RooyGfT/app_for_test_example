import 'dart:convert';

import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';

class TodoModel extends Todo{

  const TodoModel({
    super.id,
    required super.description, 
    required super.done
  });

  factory TodoModel.fromJson(Map<String,dynamic> json){
    return TodoModel(
      id: json["id"],
      description: json["description"] as String, 
      done: json["done"] == 1 
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'description':description,
      'done':done ?1:0
    };
  }

  static List<TodoModel> decodeList(String todosString) => 
  (json.encode(todosString) as List<dynamic>)
    .map((e) => TodoModel.fromJson(e as Map<String,dynamic>))
    .toList();



}