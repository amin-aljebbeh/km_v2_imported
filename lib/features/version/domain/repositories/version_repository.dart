import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';

abstract class VersionRepository {
  Future<Either<Failure, Unit>> checkVersion({String appVersion, String platform});
}
