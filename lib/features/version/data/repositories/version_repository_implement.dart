import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/version_repository.dart';
import '../data_sources/version_remote_data_source.dart';

class VersionRepositoryImplement extends VersionRepository {
  final VersionRemoteDataSource versionRemoteDataSource;
  final RepositoryFactory repositoryFactory;

  VersionRepositoryImplement({this.versionRemoteDataSource, this.repositoryFactory});

  @override
  Future<Either<Failure, Unit>> checkVersion({String appVersion, String platform}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => versionRemoteDataSource.checkVersion(appVersion: appVersion, platform: platform));
  }
}
