
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/data/datasource/local/locla_data_source.dart';
import 'package:todo_app/data/datasource/local/pending_action_storage.dart';
import 'package:todo_app/data/datasource/remote/remote_data_source.dart';
import 'package:todo_app/data/repository/todo_repo_impl.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';
import 'package:todo_app/presentation/cubit/todo_cubit.dart';

import '../network_layer/dio_client.dart';
import '../services/sync_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // dio
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Data source
  sl.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceImplementation(dioClient: sl()),
  );
  sl.registerLazySingleton<LocalDataSource>(
        () => LocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(
        () => TodoRepositoryImpl(remoteDataSource: sl(),local: sl()),
  );
  sl.registerLazySingleton<PendingActionsStorage>(
        () => PendingActionsStorage(),
  );

 //cubit
  sl.registerFactory(
        () => TodoCubit(todoRepository: sl(),pendingActionsStorage: sl()),
  );
  //syncservice
  sl.registerLazySingleton<SyncService>(
        () => SyncService(
      local: sl<PendingActionsStorage>(),
      remote: sl<TodoRepository>(),
    ),
  );
}
