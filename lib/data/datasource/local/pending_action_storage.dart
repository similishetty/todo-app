import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/pending_action_model.dart';

class PendingActionsStorage {
  static const String _key = 'PENDING_ACTIONS';

  /// Save a pending action
  Future<void> savePendingAction(PendingAction action) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    List decoded = jsonString != null ? json.decode(jsonString) : [];
    decoded.add(action.toJson());
    await prefs.setString(_key, json.encode(decoded));
  }

  /// Get all pending actions
  Future<List<PendingAction>> getPendingActions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      return decoded.map((e) => PendingAction.fromJson(e)).toList();
    }
    return [];
  }

  /// Clear all synced actions
  Future<void> clearPendingActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
