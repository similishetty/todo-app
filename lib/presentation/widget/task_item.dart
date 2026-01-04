import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entity/todo_entity.dart';

import '../cubit/todo_cubit.dart';

class TaskItem extends StatelessWidget {
  final TodoEntity todo;
  const TaskItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: todo.completed,
          onChanged: (val) {
            context.read<TodoCubit>().markTodoAsCompleted(
              todo.id ?? 0,
              val ?? false,
            );
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(todo.title ?? '')],
          ),
        ),
        IconButton(
          onPressed: () {
            context.read<TodoCubit>().deleteTodo(todo.id ?? 0);
          },
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }
}
