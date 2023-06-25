import '../../../../core/core_importer.dart';
import '../../domain/use_cases/authentication_cases.dart';

@immutable
class AuthenticationState extends Equatable {
  final AuthenticationUseCases authenticationUSeCases;

  const AuthenticationState({this.authenticationUSeCases});

  factory AuthenticationState.initial() {
    return AuthenticationState(authenticationUSeCases: sl<AuthenticationUseCases>());
  }

  AuthenticationState copyWith() {
    return AuthenticationState(authenticationUSeCases: authenticationUSeCases);
  }

  @override
  List<Object> get props => [authenticationUSeCases];
}
