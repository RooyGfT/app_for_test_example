import 'package:equatable/equatable.dart';

class Todo extends Equatable {

  final int? id;
  final String description;
  final bool done;

  const Todo({
    this.id,
    required this.description,
    required this.done
  });

  @override
  List<Object?> get props => [description,done];

}