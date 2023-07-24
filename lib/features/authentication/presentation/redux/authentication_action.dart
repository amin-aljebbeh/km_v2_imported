import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/authentication/presentation/redux/authentication_state.dart';

import '../../../../core/core_importer.dart';

abstract class AuthenticationAction {
  handle({@required Store<AppState> store, AuthenticationState state});
}

class LoginAction extends AuthenticationAction {
  final String name;
  final String password;
  final BuildContext context;

  LoginAction({this.name, this.password, this.context});

  @override
  handle({Store<AppState> store, AuthenticationState state}) async {
    if (['shopper', 'supplier', 'rabia', 'agent', 'collector'].contains(name)) baseUrl = testUrl;
    store.dispatch(StartLoading());

    Either either = await state.authenticationUSeCases.loginUseCase(username: name, password: password);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'خطأ باسم المستخدم أو كلمة المرور')), (response) {
      TextInput.finishAutofillContext();
      KammunRestart.restartApp(context);
    });
    store.dispatch(StopLoading());
  }
}

class LogoutAction extends AuthenticationAction {
  final BuildContext context;

  LogoutAction({this.context});

  @override
  handle({Store<AppState> store, AuthenticationState state}) async {
    Either either = await state.authenticationUSeCases.logoutUseCase();
    either.fold((failure) {}, (response) {
      store.dispatch(RestartApp());
      KammunRestart.restartApp(context);
    });
  }
}
