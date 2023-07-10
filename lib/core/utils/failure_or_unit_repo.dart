import 'package:dartz/dartz.dart';

import '../core_importer.dart';

class RepositoryFactory {
  RepositoryFactory();

  Future<Either<Failure, Unit>> failureUnitRepo({Future<Unit> Function() function}) async {
    try {
      await function();
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure(message: e.toString()));
    }
  }
}
