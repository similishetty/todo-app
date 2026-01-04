import 'package:dartz/dartz.dart';
import 'package:todo_app/data/datasource/remote/remote_data_source.dart';
import 'package:todo_app/data/model/todo_model.dart';

import 'package:todo_app/domain/entity/todo_entity.dart';

import 'package:todo_app/network_layer/app_exception.dart';

import '../../domain/repository/todo_repo.dart';
import '../datasource/local/locla_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource local;


  TodoRepositoryImpl({required this.remoteDataSource,required this.local});

  @override
  Future<Either<AppException, List<TodoEntity>>> getTodos() async {
    try {
      final List<TodoModel> result = await remoteDataSource.getTodo();
      await local.cacheTodos(result); // cache
      final List<TodoEntity> entity = result.map((val) =>
          TodoEntity(userId: val.userId,
              id: val.id,
              title: val.title,
              completed: val.completed)).toList();
      return Right(entity);
    } on AppException catch (e) {
      // get cached data on failure
      final cached = await local.getCachedTodos();
      final List<TodoEntity> entity = cached.map((val) =>
          TodoEntity(userId: val.userId,
              id: val.id,
              title: val.title,
              completed: val.completed)).toList();
      return Right(entity);
    }
  }

  @override
  Future<Either<AppException, TodoEntity>> createTodo(TodoEntity todo) async {
    try {
      final TodoModel result = await remoteDataSource.postTodo(todo: todo);
      final TodoEntity entity =
      TodoEntity(userId: result.userId,
          id: result.id,
          title: result.title,
          completed: result.completed);
      return Right(entity);
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<AppException, TodoEntity>> deleteTodo(int id) async {
    try {
      final TodoModel result = await remoteDataSource.deleteTodo(id: id);
      final TodoEntity entity =
          TodoEntity(userId: result.userId,
              id: result.id,
              title: result.title,
              completed: result.completed);
      return Right(entity);
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<AppException, TodoEntity>> markAsComplete(int id, bool markAsCompleted) async{
    try {
      final TodoModel result = await remoteDataSource.completeTodo(isCompleted: markAsCompleted, id: id);
      final TodoEntity entity =
          TodoEntity(userId: result.userId,
              id: result.id,
              title: result.title,
              completed: result.completed);
      return Right(entity);
    } on AppException catch (e) {
      return Left(e);
    }
  }
}