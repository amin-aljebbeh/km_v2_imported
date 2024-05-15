import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/todos/domain/repositories/todos_repository.dart';

import '../../../../core/core_importer.dart';

class ResolveTodoUseCase {
  final TodosRepository todosRepository;

  ResolveTodoUseCase({this.todosRepository});

  Future<Either<Failure, Unit>> call({int todoId, int todoTagResolverId, String note}) async {
    return await todosRepository.resolveTodo(note: note, todoId: todoId, todoTagResolverId: todoTagResolverId);
  }
}
