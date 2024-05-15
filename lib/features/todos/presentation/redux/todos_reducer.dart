import '../../../../core/core_importer.dart';
import 'todos_action.dart';
import 'todos_state.dart';

Reducer<TodosState> todosReducer = combineReducers<TodosState>([
  TypedReducer<TodosState, SetTodos>(setTodos),
  TypedReducer<TodosState, SetHasNextTodos>(setHasNextTodos),
  TypedReducer<TodosState, SetTodosPageNumber>(setTodosPageNumber),
]);

TodosState setTodos(TodosState state, SetTodos action) => state.copyWith(todos: action.todos);

TodosState setTodosPageNumber(TodosState state, SetTodosPageNumber action) =>
    state.copyWith(todoPageNumber: action.pageNumber);

TodosState setHasNextTodos(TodosState state, SetHasNextTodos action) =>
    state.copyWith(hasNextTodos: action.hasNextTodos);
