import '../../../../core/core_importer.dart';
import 'error_state.dart';

final errorReducer = combineReducers<ErrorState>([
  TypedReducer<ErrorState, NoError>(initialError),
  TypedReducer<ErrorState, CatchError>(catchError),
]);

ErrorState initialError(ErrorState state, NoError action) => ErrorState.initial();

ErrorState catchError(ErrorState state, CatchError action) =>
    state.copyWith(isError: true, errorMessage: action.errorMessage, viewError: action.viewError);
