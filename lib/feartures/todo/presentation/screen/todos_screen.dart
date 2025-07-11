import 'package:app_for_test_example/feartures/todo/data/models/todo_model.dart';
import 'package:app_for_test_example/feartures/todo/presentation/viewmodels/todo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(todoViewModelProvider.notifier).getAllTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Todos")),
      body: TodosBody(state: state),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final todo = TodoModel(description: "Nuevo todo", done: false);
          ref.read(todoViewModelProvider.notifier).saveTodo(todo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodosBody extends StatelessWidget {
  const TodosBody({super.key, required this.state});

  final TodosState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Error: ${state.error}",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return CheckboxListTile(
                title: Text(todo.description),
                value: todo.done,
                onChanged: (value) {
                  // Aquí podrías implementar lógica para actualizar el estado del todo
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
