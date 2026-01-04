import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/domain/entity/todo_entity.dart';

abstract class LocalDataSource {
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<List<TodoModel>> getCachedTodos();
}
class LocalDataSourceImpl implements LocalDataSource {
  static const String _todosKey = 'CACHED_TODOS';

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((t) => t.toJson()).toList();
    prefs.setString(_todosKey, json.encode(jsonList));
  }

  @override
  Future<List<TodoModel>> getCachedTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('CACHED_TODOS');
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((json) => TodoModel.fromJson(json)).toList();
    }
    return [];
  }
}

