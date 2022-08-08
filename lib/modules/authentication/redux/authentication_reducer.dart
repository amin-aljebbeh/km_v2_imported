import '../../../core/core_importer.dart';
import 'authentication_action.dart';
import 'authentication_state.dart';

Reducer<AuthenticationState> authenticationReducer = combineReducers<AuthenticationState>([
  TypedReducer<AuthenticationState, EnterNumber>(enterNumber),
  TypedReducer<AuthenticationState, ReSendCode>(reSendCode),
  TypedReducer<AuthenticationState, UserNotLoggedIn>(userNotLoggedIn),
  TypedReducer<AuthenticationState, BlockedUser>(blockUser),
  TypedReducer<AuthenticationState, SetUserId>(setUserId),
  TypedReducer<AuthenticationState, SetToken>(setToken),
]);

AuthenticationState enterNumber(AuthenticationState state, EnterNumber action) {
  return state.copyWith(phoneNumber: action.phoneNumber);
}

AuthenticationState reSendCode(AuthenticationState state, ReSendCode action) {
  return state.copyWith(reSendCode: action.reSend);
}

AuthenticationState userNotLoggedIn(AuthenticationState state, UserNotLoggedIn action) {
  return AuthenticationState.initial();
}

AuthenticationState blockUser(AuthenticationState state, BlockedUser action) {
  return state.copyWith(blockedUser: true, token: '', isLoggedIn: false);
}

AuthenticationState setUserId(AuthenticationState state, SetUserId action) {
  return state.copyWith(userId: action.userId);
}

AuthenticationState setToken(AuthenticationState state, SetToken action) {
  return state.copyWith(token: action.token, isLoggedIn: true);
}
