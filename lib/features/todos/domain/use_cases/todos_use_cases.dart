import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/todos/domain/use_cases/get_todos_use_case.dart';

import 'resolve_todo_use_case.dart';

class TodosUseCases {
  final ResolveTodoUseCase resolveTodoUseCase;
  final GetTodosUseCase getTodosUseCase;

  TodosUseCases({@required this.getTodosUseCase, @required this.resolveTodoUseCase})
      : assert(getTodosUseCase != null && resolveTodoUseCase != null, 'All use cases should be initialized.');
}
