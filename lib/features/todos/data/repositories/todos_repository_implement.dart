import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';
import 'package:kammun_app/features/todos/domain/repositories/todos_repository.dart';

import '../../../../core/core_importer.dart';
import '../data_sources/todos_remote_data_source.dart';

class TodosRepositoryImplement extends TodosRepository {
  final TodosRemoteDataSource todosRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  TodosRepositoryImplement({this.todosRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, TodoResponseEntity>> getTodos({int page}) async {
    try {
      TodoResponseEntity todoResponseEntity = await todosRemoteDataSource.getTodos(page: page);
      return Right(todoResponseEntity);
    } on CacheException {
      return Left(CacheFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resolveTodo({int todoId, int todoTagResolverId, String note}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () =>
            todosRemoteDataSource.resolveTodo(note: note, todoTagResolverId: todoTagResolverId, todoId: todoId));
  }
}
