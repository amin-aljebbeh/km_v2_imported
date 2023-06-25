import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../core/core_importer.dart';

class LogoutUseCase {
  final AuthenticationRepository authenticationRepository;

  LogoutUseCase({this.authenticationRepository});

  Future<Either<Failure, Unit>> call() async {
    return await authenticationRepository.logout();
  }
}
