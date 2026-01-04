import '../../domain/entity/todo_entity.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  final List<TodoEntity>? filteredTodos;
  final bool scrollToTop;
  TodoLoaded(this.todos, {this.scrollToTop = false,this.filteredTodos});
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}