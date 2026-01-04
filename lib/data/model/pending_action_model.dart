import 'package:todo_app/domain/entity/todo_entity.dart';

enum PendingActionType { create, delete, complete }

class PendingAction {
  final int todoId;
  final PendingActionType type;
  final bool? markAsCompleted;
  final TodoEntity? data; // for creating

  PendingAction(this.todoId, this.type, {this.data,this.markAsCompleted});

  Map<String, dynamic> toJson() => {
    'todoId': todoId,
    'type': type.name,
    'data': data?.toJson(),
    'markAsCompleted': markAsCompleted,
  };

  factory PendingAction.fromJson(Map<String, dynamic> json) {
    return PendingAction(
      json['todoId'],
      PendingActionType.values.firstWhere((e) => e.name == json['type']),
      data: json['data'] != null
          ? TodoEntity.fromJson(json['data'])
          : null,
      markAsCompleted: json['markAsCompleted'],
    );
  }
}
