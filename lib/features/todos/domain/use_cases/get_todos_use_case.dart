import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/todos/domain/repositories/todos_repository.dart';

import '../../../../core/core_importer.dart';
import '../entities/todo_entity.dart';

class GetTodosUseCase {
  final TodosRepository todosRepository;

  GetTodosUseCase({this.todosRepository});

  Future<Either<Failure, TodoResponseEntity>> call({int page}) async {
    return await todosRepository.getTodos(page: page);
  }
}
