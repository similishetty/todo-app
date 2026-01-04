import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entity/todo_entity.dart';
import 'package:todo_app/presentation/cubit/todo_cubit.dart';
import 'package:todo_app/presentation/cubit/todo_state.dart';
import 'package:todo_app/presentation/widget/task_item.dart';


class TodoLandingScreen extends StatefulWidget {
  const TodoLandingScreen({super.key});

  @override
  State<TodoLandingScreen> createState() => _TodoLandingScreenState();
}

class _TodoLandingScreenState extends State<TodoLandingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          openAddTaskSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Task Manager")),
      body: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is TodoLoaded && state.scrollToTop) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
          if (state is TodoError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TodoLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoCubit>().fetchTodos();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<TodoCubit>().searchTodos(value);
                      },
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.filteredTodos?.length ?? 0,
                      itemBuilder: (context, index) {
                        final todo = state.filteredTodos?[index];
                        return TaskItem(
                          key: ValueKey(todo?.id),
                          todo: todo ?? TodoEntity(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  void openAddTaskSheet(BuildContext parentContext) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (parentContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Task title',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.text.trim().isEmpty) return;

                        context.read<TodoCubit>().createTodo(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
