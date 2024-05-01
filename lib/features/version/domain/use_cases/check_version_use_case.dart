import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../repositories/version_repository.dart';

class CheckVersionUseCase {
  final VersionRepository versionRepository;

  CheckVersionUseCase({this.versionRepository});

  Future<Either<Failure, Unit>> call({String appVersion, String platform}) async {
    return await versionRepository.checkVersion(appVersion: appVersion, platform: platform);
  }
}
