import 'package:kammun_app/core/core_importer.dart';

import 'login_use_case.dart';
import 'logout_use_case.dart';

class AuthenticationUseCases {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthenticationUseCases({@required this.loginUseCase, @required this.logoutUseCase})
      : assert(loginUseCase != null && logoutUseCase != null, 'All use cases should be initialized.');
}
