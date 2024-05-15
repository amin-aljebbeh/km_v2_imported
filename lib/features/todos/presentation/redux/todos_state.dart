import 'package:kammun_app/features/todos/domain/entities/todo_entity.dart';
import 'package:kammun_app/features/todos/domain/use_cases/todos_use_cases.dart';

import '../../../../core/core_importer.dart';

@immutable
class TodosState extends Equatable {
  final TodosUseCases todosUseCase;
  final List<TodoEntity> todos;
  final bool hasNextTodos;
  final int todoPageNumber;

  const TodosState({this.todosUseCase, this.hasNextTodos, this.todos, this.todoPageNumber});

  factory TodosState.initial() {
    return TodosState(todos: const [], todosUseCase: sl<TodosUseCases>(), hasNextTodos: true, todoPageNumber: 1);
  }

  TodosState copyWith({List<TodoEntity> todos, bool hasNextTodos, int todoPageNumber}) {
    return TodosState(
      todoPageNumber: todoPageNumber ?? this.todoPageNumber,
      hasNextTodos: hasNextTodos ?? this.hasNextTodos,
      todos: todos ?? this.todos,
      todosUseCase: todosUseCase,
    );
  }

  @override
  List<Object> get props => [todoPageNumber, hasNextTodos, todos, todosUseCase];
}
