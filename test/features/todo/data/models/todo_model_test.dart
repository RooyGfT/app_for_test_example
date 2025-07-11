import 'dart:convert';

import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';


void main(){

  final testTodoModel = TodoModel(id: 1,description: "Test Description", done: true);

  test('Should be a subclass of Todo entity', () async{
    expect(testTodoModel, isA<Todo>());
  });

  group('From json', (){
    test(
      'Should return a valid model when done is 1',(){
        //arrange
        final Map<String,dynamic> jsonMap = json.decode(fixture('todo_true.json'));

        //act
        final result = TodoModel.fromJson(jsonMap);

        //assert
        expect(result, testTodoModel);
    });

    test(
      'Should return a valid model when done is 1',(){

        //arrange
        final testTodoModelFalse = TodoModel(description: "Test Description", done: false);
        final Map<String,dynamic> jsonMap = json.decode(fixture('todo_false.json'));

        //act
        final result = TodoModel.fromJson(jsonMap);

        //assert
        expect(result, testTodoModelFalse);
    });

    group('toJson', (){
      test('Should return a JSON Map containing the proper data', () {

        //arrange
        final expectedMap = {
          'id':1,
          'description': 'Test Description',
          'done':1
        };
        //act
        final result = testTodoModel.toJson();

        //assert
        expect(result, expectedMap);
      });
    });
  });
}