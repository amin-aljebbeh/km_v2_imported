import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';

import '../../../../core/core_importer.dart';

abstract class TodosRepository {
  Future<Either<Failure, Unit>> resolveTodo({int todoId, int todoTagResolverId, String note});

  Future<Either<Failure, TodoResponseEntity>> getTodos({int page});
}
