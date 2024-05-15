import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/todo_entity.dart';

abstract class TodosAction {
  handle({@required Store<AppState> store});
}

class GetTodosAction implements TodosAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());

    Either either =
        await store.state.todosState.todosUseCase.getTodosUseCase(page: store.state.todosState.todoPageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ، يرجى المحاولة مجدداً')), (response) {
      TodoResponseEntity responseEntity = response;
      List<TodoEntity> todos = [];
      todos.addAll(store.state.todosState.todos);
      todos.addAll(responseEntity.data.data);
      store.dispatch(SetTodos(todos: todos));
      if (responseEntity.data.currentPage == responseEntity.data.lastPage) {
        store.dispatch(SetHasNextTodos(hasNextTodos: false));
      }
    });
    store.dispatch(StopLoading());
  }
}

class SetTodos {
  final List<TodoEntity> todos;

  SetTodos({this.todos});
}

class SetHasNextTodos {
  final bool hasNextTodos;

  SetHasNextTodos({this.hasNextTodos});
}

class SetTodosPageNumber {
  final int pageNumber;

  SetTodosPageNumber({this.pageNumber});
}
