
#  Todo App (Flutter)

A Flutter Todo application built using **Clean Architecture**, **BLoC**, and **offline sync**.  
The app supports creating, deleting, completing tasks with offline persistence and automatic syncing when the network is restored.

---

## Features

-  Create, delete, and complete tasks
-  Offline support with pending action sync
-  Automatic sync when network reconnects
-  Search tasks by title
- ️ Pull-to-refresh
-  Clean Architecture (Data / Domain / Presentation)
-  Dependency Injection using GetIt
-  State management with Flutter Bloc


## Offline Sync Flow

1. User performs an action (create / delete / complete)
2. Action is saved locally using `SharedPreferences`
3. UI updates immediately (optimistic update)
4. When network becomes available:
    - Pending actions are synced to the server
    - Successfully synced actions are removed from local storage



## State Management
The app uses **flutter_bloc** for state management.

### States
- `TodoInitial`
- `TodoLoading`
- `TodoLoaded`
- `TodoError`
- 
The UI reacts to above state changes.

## Getting started
git clone https://github.com/similishetty/todo-app.git
flutter pub get 
flutter run