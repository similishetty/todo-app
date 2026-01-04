

import 'package:todo_app/domain/entity/todo_entity.dart';

import '../data/datasource/local/pending_action_storage.dart';
import '../data/model/pending_action_model.dart';
import '../domain/repository/todo_repo.dart';

class SyncService {
  final PendingActionsStorage local;
  final TodoRepository remote;

  SyncService({
    required this.local,
    required this.remote,
  });

  /// Sync all pending actions with the server
  Future<void> syncPendingActions() async {
    final actions = await local.getPendingActions();
    final synced = <PendingAction>[];

    for (final action in actions) {
      try {
        if (action.type == PendingActionType.complete) {
          await remote.markAsComplete(
              action.todoId, action.markAsCompleted ?? false);
        } else if (action.type == PendingActionType.delete) {
          await remote.deleteTodo(action.todoId);
        } else
        if (action.type == PendingActionType.create && action.data != null) {
          final data = TodoEntity(id: action.data?.id,
              userId: action.data?.userId,
              completed: action.data?.completed,
              title: action.data?.title);
          await remote.createTodo(data);
        }
        synced.add(action);
      } catch (e) {
        print('Failed to sync action: ${action.type} for ${action.todoId}');
      }
    }
    // remove synced action
    if (synced.isNotEmpty) {
      final allActions = await local.getPendingActions();
      final remaining = allActions.where((a) => !synced.contains(a)).toList();
      await local.clearPendingActions();
      // remaining to save again
      for (var action in remaining) {
        await local.savePendingAction(action);
      }
    }
  }
  }

