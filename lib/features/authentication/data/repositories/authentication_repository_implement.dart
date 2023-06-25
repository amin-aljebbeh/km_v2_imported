import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/authentication/data/data_sources/authentication_remote_data_source.dart';

import '../../../../core/core_importer.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../data_sources/authentication_local_data_source.dart';

class AuthenticationRepositoryImplement implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;
  final AuthenticationLocalDataSource authenticationLocalDataSource;
  final RepositoryFactory repositoryFactory;

  AuthenticationRepositoryImplement(
      {this.authenticationRemoteDataSource, this.repositoryFactory, this.authenticationLocalDataSource});

  @override
  Future<Either<Failure, Unit>> login({String username, String password}) async {
    return await repositoryFactory.failureUnitRepo(
        function: () => authenticationRemoteDataSource.login(password: password, username: username));
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return await repositoryFactory.failureUnitRepo(function: () => authenticationLocalDataSource.logout());
  }
}
