import 'package:dartz/dartz.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/domain/entity/todo_entity.dart';
import 'package:todo_app/network_layer/app_exception.dart';

abstract class TodoRepository{
  Future<Either<AppException, List<TodoEntity>>> getTodos();
   Future<Either<AppException, TodoEntity>> deleteTodo(int id);
   Future<Either<AppException,  TodoEntity>> markAsComplete(int id,bool markAsCompleted);
   Future<Either<AppException,  TodoEntity>> createTodo(TodoEntity todo);
}