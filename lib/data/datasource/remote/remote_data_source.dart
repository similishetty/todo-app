import 'package:dio/dio.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/domain/entity/todo_entity.dart';
import 'package:todo_app/network_layer/dio_client.dart';

import '../../../network_layer/app_exception.dart';

abstract class RemoteDataSource {
  Future<List<TodoModel>> getTodo();
  Future <TodoModel> deleteTodo({required int id});
  Future <TodoModel>  postTodo({required TodoEntity todo});
  Future <TodoModel>  completeTodo({required isCompleted, required int id});
}

class RemoteDataSourceImplementation implements RemoteDataSource {
  final DioClient dioClient;
  RemoteDataSourceImplementation({required this.dioClient});

  @override
  Future<List<TodoModel>> getTodo() async {
    try {
      final Response response = await dioClient.dio.get('/todos');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return (data as List)
              .map((json) => TodoModel.fromJson(json))
              .toList();
        } else {
          throw NetworkException("Failed to load todos");
        }
      }
      throw NetworkException("Failed to load todos");
    } catch (e) {
      throw NetworkException("Failed to load todos");
    }
  }

  @override
  Future <TodoModel> postTodo({required TodoEntity todo}) async {
    try {
      final Response response = await dioClient.dio.post('/todos',data: {
        "userId": todo.userId,
        "title": todo.title,
        "completed": todo.completed,
      });
      if (response.statusCode == 200 || response.statusCode==201) {
        final data = response.data;
        if (data != null) {
          return TodoModel.fromJson(data);
        } else {
          throw NetworkException("Failed to load todos");
        }
      }
      throw NetworkException("Failed to load todos");
    } catch (e) {
      throw NetworkException("Failed to load todos");
    }
  }

  @override
  Future <TodoModel>  completeTodo({required isCompleted, required int id}) async{
    try {
      final Response response = await dioClient.dio.patch('/todos/$id',data: {
        'completed'  : isCompleted
      });
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return TodoModel.fromJson(data);
        } else {
          throw NetworkException("Failed to load todos");
        }
      }
      throw NetworkException("Failed to load todos");
    } catch (e) {
      throw NetworkException("Failed to load todos");
    }
  }

  @override
  Future <TodoModel>  deleteTodo({required int id})async {
    try {
      final Response response = await dioClient.dio.delete('/todos/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return TodoModel.fromJson(data);
        } else {
          throw NetworkException("Failed to load todos");
        }
      }
      throw NetworkException("Failed to load todos");
    } catch (e) {
      throw NetworkException("Failed to load todos");
    }
  }


}
