import '../../../core/core_importer.dart';
import 'error_state.dart';

final errorReducer = combineReducers<ErrorState>([
  TypedReducer<ErrorState, NoError>(initialError),
  TypedReducer<ErrorState, CatchError>(catchError),
  TypedReducer<ErrorState, SetUrl>(setUrl),
  TypedReducer<ErrorState, SetStatusCode>(setStatusCode),
]);

ErrorState initialError(ErrorState state, NoError action) {
  return ErrorState.initial();
}

ErrorState catchError(ErrorState state, CatchError action) {
  return state.copyWith(isError: true, errorMessage: action.errorMessage, viewError: action.viewError);
}

ErrorState setUrl(ErrorState state, SetUrl action) {
  return state.copyWith(url: action.url);
}

ErrorState setStatusCode(ErrorState state, SetStatusCode action) {
  return state.copyWith(statusCode: action.statusCode);
}
