import 'package:kammun_app/features/todos/data/data_sources/todos_remote_data_source.dart';
import 'package:kammun_app/features/todos/data/repositories/todos_repository_implement.dart';
import 'package:kammun_app/features/todos/domain/repositories/todos_repository.dart';

import '../core/core_importer.dart';
import '../features/todos/domain/use_cases/get_todos_use_case.dart';
import '../features/todos/domain/use_cases/resolve_todo_use_case.dart';
import '../features/todos/domain/use_cases/todos_use_cases.dart';

Future<void> injectTodos() async {
  sl.registerLazySingleton(() => ResolveTodoUseCase(todosRepository: sl()));
  sl.registerLazySingleton(() => GetTodosUseCase(todosRepository: sl()));
  sl.registerLazySingleton<TodosUseCases>(() => TodosUseCases(getTodosUseCase: sl(), resolveTodoUseCase: sl()));
  sl.registerLazySingleton<TodosRepository>(
      () => TodosRepositoryImplement(todosRemoteDataSource: sl(), repositoryFactory: sl()));
  sl.registerLazySingleton<TodosRemoteDataSource>(() => TodosRemoteDataSourceImplement());
}
