import 'package:dartz/dartz.dart';

import '../core_importer.dart';

class RepositoryFactory {
  final InternetConnectionChecker internetConnectionChecker;

  RepositoryFactory({this.internetConnectionChecker});
  Future<Either<Failure, Unit>> failureUnitRepo({Future<Unit> Function() function}) async {
    if (!await internetConnectionChecker.hasConnection) return Left(OfflineFailure());
    try {
      await function();
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    } on OfflineException {
      return Left(OfflineFailure());
    } catch (e) {
      return Left(InternalFailure());
    }
  }
}
