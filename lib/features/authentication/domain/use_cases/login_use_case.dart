import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../core/core_importer.dart';

class LoginUseCase {
  final AuthenticationRepository authenticationRepository;

  LoginUseCase({this.authenticationRepository});

  Future<Either<Failure, Unit>> call({String username, String password}) async {
    return await authenticationRepository.login(password: password, username: username);
  }
}
