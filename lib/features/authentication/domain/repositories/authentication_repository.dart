import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, Unit>> login({String username, String password});
  Future<Either<Failure, Unit>> logout();
}
