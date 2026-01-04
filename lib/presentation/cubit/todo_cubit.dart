import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/datasource/local/pending_action_storage.dart';
import 'package:todo_app/data/model/pending_action_model.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';
import 'package:todo_app/presentation/cubit/todo_state.dart';

import '../../domain/entity/todo_entity.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository todoRepository;
  final PendingActionsStorage pendingActionsStorage;
  TodoCubit({required this.todoRepository, required this.pendingActionsStorage})
    : super(TodoInitial());

  void fetchTodos() async {
    emit(TodoLoading());
    final result = await todoRepository.getTodos();
    result.fold(
      (failure) {
        emit(TodoError(failure.message));
      },
      (todo) {
        emit(TodoLoaded(todo,filteredTodos: todo));
      },
    );
  }

  void deleteTodo(int id) async {
    // emit(TodoLoading());
    if (state is TodoLoaded) {
      final currentTodo = (state as TodoLoaded).todos;
      final updatedTodo = currentTodo.where((t) => t.id != id).toList();
      try {
        final result = await todoRepository.deleteTodo(id);

        result.fold(
          (failure) {
            emit(TodoError(failure.message));
          },
          (success) {
            emit(TodoLoaded(updatedTodo,filteredTodos: updatedTodo));
          },
        );
      } catch (e) {
        await pendingActionsStorage.savePendingAction(
          PendingAction(id, PendingActionType.delete),
        );
      }
    }
  }

  void markTodoAsCompleted(int id, bool markAsCompleted) async {
    if (state is TodoLoaded) {
      final currentTodo = (state as TodoLoaded).todos;
      final updatedTodo = currentTodo.map((t) {
        if (t.id == id) {
          return TodoEntity(
            id: t.id,
            userId: t.userId,
            title: t.title,
            completed: markAsCompleted,
          );
        }
        return t;
      }).toList();
      try {
        final result = await todoRepository.markAsComplete(id, markAsCompleted);
        result.fold(
          (failure) {
            emit(TodoError(failure.message));
          },
          (success) {
            emit(TodoLoaded(updatedTodo,filteredTodos: updatedTodo));
          },
        );
      } catch (e) {
        await pendingActionsStorage.savePendingAction(
          PendingAction(
            id,
            PendingActionType.complete,
            markAsCompleted: markAsCompleted,
          ),
        );
      }
    }
  }

  void createTodo(String todoTitle) async {
    final todo = TodoEntity(userId: 1, completed: false, title: todoTitle);
    if (state is TodoLoaded) {
      final current = (state as TodoLoaded).todos;
      try {
        final result = await todoRepository.createTodo(todo);

        result.fold(
          (failure) {
            emit(TodoError(failure.message));
            emit(TodoLoaded(current));
          },
          (createdTodo) {
            final finalTodos = [createdTodo, ...current];
            emit(TodoLoaded(finalTodos, scrollToTop: true,filteredTodos: finalTodos));
          },
        );
      } catch (e) {
        await pendingActionsStorage.savePendingAction(
          PendingAction(todo.id ?? 0, PendingActionType.create, data: todo),
        );
      }
    }
  }

  void searchTodos(String query) {
    if (state is TodoLoaded) {
      final loaded = state as TodoLoaded;

      if (query.isEmpty) {
        emit(TodoLoaded(loaded.todos, filteredTodos: loaded.todos));
      } else {
        final filtered = loaded.todos
            .where(
              (todo) => (todo.title ?? '').toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();

        emit(TodoLoaded(loaded.todos, filteredTodos: filtered));
      }
    }
  }
}
